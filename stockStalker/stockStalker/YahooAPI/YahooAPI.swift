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
    func decode<T: Decodable>(_ data: Data) throws -> T
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
    
    func urlRequest(_ config: NetworkConfig) throws -> URLRequest {
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

