//
//  YahooAPI.swift
//  stockStalker
//
//  Created by WISA Mobile on 2/27/25.
//

import Foundation

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
}

enum HttpMethod: String {
    case get = "GET"
}
protocol BodyEncoder {
    func encode<T: Encodable>(_ param: T) -> Data?
}

protocol ResponseDecoder {
    func decode<T: Codable>(_ data: Data) throws -> T
}

final class EntitiyTypeResponseDecoder: ResponseDecoder {
    let decoder = JSONDecoder()
    
    func decode<T>(_ data: Data) throws -> T where T : Codable {
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
        var base = URLSessionConfiguration.default
        base.httpAdditionalHeaders = config.header
        return base
    }
}

final class EndPoint<T>: Requestable {
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
    func fetchAPI(endpoint: Requestable) async throws -> Result<Data, Error>
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
}

extension DefaultAsyncNetworkService: AsyncNetworkService {
    func fetchAPI(endpoint: any Requestable) async throws -> Result<Data, Error> {
       let result = await Task {
           let (data, response) =  try await _session.request(req: getRequest(endpoint), config: endpoint.urlSessionConfiguration(_configuration))
       }.result
    }
}
