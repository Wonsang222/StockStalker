//
//  MockResponseDecoder.swift
//  stockStalkerTests
//
//  Created by Wonsang Hwang on 3/9/25.
//

import Foundation
@testable import stockStalker

final class MockResponseDecoder: ResponseDecoder {
    
    private let _decoder = JSONDecoder()
    
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        return try _decoder.decode(T.self, from: data)
    }
}
