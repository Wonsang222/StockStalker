//
//  YahooAPI.swift
//  stockStalker
//
//  Created by Wonsang HWang on 2/27/25.
//

import Foundation
import RxSwift

protocol NetworkConfigurable {
    var baseURL: String { get }
    var header: [String:String] { get }
}

struct NetworkConfig: NetworkConfigurable {
    let baseURL: String
    let header: [String : String]
}

enum NetworkError: Error {
    case urlComponent
    case url
    case wrongResponse
    case dataParse
    case cancellation
    case api
}

enum HttpMethod: String {
    case get = "GET"
}
protocol BodyEncoder {
    func encode<T: Encodable>(_ param: T) -> Data?
}

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

final class EntitiyTypeResponseDecoder: ResponseDecoder {
    let decoder = JSONDecoder()
    
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        return try decoder.decode(T.self, from: data)
    }
}

protocol Requestable {
    var path: String? { get }
    var method: HttpMethod { get }
    var queryParameter: [String:String] { get }
    var header: [String:String] { get }
    var body: Encodable? { get }
    var bodyEncoder: BodyEncoder? { get }
}

extension Requestable {
    func url(_ config: NetworkConfigurable) throws -> URL {
        var baseURL = config.baseURL
        
        if !baseURL.hasSuffix("/") {
            baseURL += "/"
        }
        
        if let path = path {
            baseURL += path
        }
        
        guard var components = URLComponents(string: baseURL) else {
            throw NetworkError.urlComponent
        }
        
        var queryComponents = [URLQueryItem]()
        
        queryParameter.forEach{ queryComponents.append(URLQueryItem(name: $0.key, value: $0.value)) }
        
        components.queryItems = queryComponents
        
        guard let finalUrl = components.url else {
            throw NetworkError.url
        }
        return finalUrl
    }
    
    func urlRequest(_ config: NetworkConfigurable) throws -> URLRequest {
        let url = try url(config)
        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        
        header.forEach{ req.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        if method.rawValue == "POST",
           let encoder = bodyEncoder,
           let body = body {
            req.httpBody = encoder.encode(body)
        }
        return req
    }
    
    func urlSessionConfiguration(_ config: NetworkConfigurable) -> URLSessionConfiguration {
        let base = URLSessionConfiguration.default
        base.httpAdditionalHeaders = config.header
        return base
    }
}

protocol ResponseRequestable: Requestable {
    
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}

final class EndPoint<T>: ResponseRequestable {
    typealias Response = T
    let path: String?
    let method: HttpMethod
    let queryParameter: [String : String]
    let header: [String : String]
    let body: (any Encodable)?
    let bodyEncoder: (any BodyEncoder)?
    let responseDecoder: ResponseDecoder
    
    init(
        path: String?,
        method: HttpMethod,
        queryParameter: [String : String],
        header: [String : String],
        body: (any Encodable)? = nil,
        bodyEncoder: (any BodyEncoder)? = nil,
        responseDecoder: ResponseDecoder)
    {
        self.path = path
        self.method = method
        self.queryParameter = queryParameter
        self.header = header
        self.body = body
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
    }
}


protocol AsyncNetworkService {
    func fetchAPI(endpoint: Requestable) async throws -> Data
}

protocol AsyncSessionManager {
    func request(req: URLRequest, config: URLSessionConfiguration) async throws -> (Data, URLResponse)
}

final class DefaultAsyncSessionManager: AsyncSessionManager {
    func request(req: URLRequest, config: URLSessionConfiguration) async throws -> (Data, URLResponse) {
        return try await URLSession(configuration: config).data(for: req)
    }
}

final class DefaultAsyncNetworkService {
    
    private let _session: AsyncSessionManager
    private let _configuration: NetworkConfigurable
    
    init(_session: AsyncSessionManager, _configuration: NetworkConfigurable) {
        self._session = _session
        self._configuration = _configuration
    }
    
    private func getRequest(_ endpoint: Requestable) throws -> URLRequest  {
        return try endpoint.urlRequest(_configuration)
    }
    
    private func getConfig(_ endpoint: Requestable) -> URLSessionConfiguration {
        return endpoint.urlSessionConfiguration(_configuration)
    }
    
    private func handleHttpResponse(_ reponse: URLResponse) throws {
        guard let response = reponse as? HTTPURLResponse else {
            throw NetworkError.wrongResponse
        }
        
        if !(200...299).contains(response.statusCode) {
            throw NetworkError.wrongResponse
        }
    }
}

extension DefaultAsyncNetworkService: AsyncNetworkService {
    func fetchAPI(endpoint: any Requestable) async throws -> Data {
            do {
                let (data, response) = try await _session.request(req: getRequest(endpoint), config: getConfig(endpoint))
                try handleHttpResponse(response)
                return data
            } catch let error {
                if let _ = error as? CancellationError {
                    throw NetworkError.cancellation
                }
                throw NetworkError.wrongResponse
            }
    }
}

protocol AsyncDataTransferService {
    func request<T: ResponseRequestable, F: Decodable>(_ endpoint: T) async throws -> F where T.Response == F
}

final class AsyncDataTransferServiceImplementaion {
    
    let _networkService: AsyncNetworkService
    
    init(_networkService: AsyncNetworkService) {
        self._networkService = _networkService
    }
    
    private func convertToResult<T: Decodable>(with decoder: ResponseDecoder, data: Data) throws -> T {
        do {
            let successData: T = try decoder.decode(data)
            return successData
        } catch {
            throw NetworkError.dataParse
        }
    }
}

extension AsyncDataTransferServiceImplementaion: AsyncDataTransferService {
    func request<T, F>(_ endpoint: T) async throws -> F where T : ResponseRequestable, F == T.Response, F: Decodable {
        let data = try await _networkService.fetchAPI(endpoint: endpoint)
        let dto: F = try convertToResult(with: endpoint.responseDecoder, data: data)
        return dto
    }
}

protocol RxDataTransferWrapperType {
    func request<T: ResponseRequestable, F: Decodable>(_ endpoint: T) -> Single<F> where F == T.Response
}

final class RxDataTransferWrapper: RxDataTransferWrapperType {
    let _asyncDataTransferService: AsyncDataTransferService
    
    init(_asyncDataTransferService: AsyncDataTransferService) {
        self._asyncDataTransferService = _asyncDataTransferService
    }
    
    func request<T, F>(_ endpoint: T) -> Single<F> where T : ResponseRequestable, F : Decodable, F == T.Response {
        return Single.create { single in
            let task =  Task {
                do {
                    let data = try await self._asyncDataTransferService.request(endpoint)
                    single(.success(data))
                } catch let error {
                    single(.failure(error))
                    }
                }
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
