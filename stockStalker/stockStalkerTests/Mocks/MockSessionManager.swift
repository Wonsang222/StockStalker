//
//  MockSession.swift
//  stockStalkerTests
//
//  Created by Wonsang Hwang on 3/21/25.
//

import Foundation
@testable import stockStalker

final class MockSessionManager: AsyncSessionManager {
    
    func request(req: URLRequest, config: URLSessionConfiguration) async throws -> (Data, URLResponse) {
        
        return (CitiBankResponseStub.getResultString().data(using: .utf8)!, URLResponse())
    }
}
