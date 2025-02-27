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
    
    
}
