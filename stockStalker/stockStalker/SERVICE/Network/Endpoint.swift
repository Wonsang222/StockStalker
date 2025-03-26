//
//  Endpoint.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/25/25.
//

import Foundation

// cache policy  -> config or request or both?  == request looks more flexible

protocol NetworkConfigurable {
    var baseURL: String { get }
    var header: [String:String] { get }
}

struct NetworkConfig: NetworkConfigurable {
    let baseURL: String
    let header: [String : String]
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
    var queryEncodable: Encodable? { get }
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
        
        if let queryEncodable = queryEncodable,
           let queries = try queryEncodable.toDic() {
            queries.forEach{ queryComponents.append(URLQueryItem(name: $0.key, value: $0.value)) }
        }
        
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
    let queryEncodable: (any Encodable)?
    let header: [String : String]
    let body: (any Encodable)?
    let bodyEncoder: (any BodyEncoder)?
    let responseDecoder: ResponseDecoder
    
    init(
        path: String?,
        method: HttpMethod,
        queryParameter: [String : String] = [:],
        queryEncodable: Encodable?,
        header: [String : String],
        body: (any Encodable)? = nil,
        bodyEncoder: (any BodyEncoder)? = nil,
        responseDecoder: ResponseDecoder)
    {
        self.path = path
        self.method = method
        self.queryParameter = queryParameter
        self.queryEncodable = queryEncodable
        self.header = header
        self.body = body
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
    }
}

fileprivate extension Encodable {
    func toDic() throws -> [String : String]? {
        let data = try JSONEncoder().encode(self)
        let json = try JSONSerialization.jsonObject(with: data)
        return json as? [String :  String]
    }
}
