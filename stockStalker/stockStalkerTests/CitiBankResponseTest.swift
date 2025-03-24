//
//  HanaBankResponseTest.swift
//  stockStalkerTests
//
//  Created by Wonsang Hwang on 3/21/25.
//

import XCTest
@testable import stockStalker

class CitiBankResponseTest: XCTestCase {
    
    var sut: AsyncSessionManager!
    
    override func setUp() async throws {
        sut = MockSessionManager()
    }
    
    override func tearDown() async throws {
        sut = nil
    }
    
    func testParseCitiBankResponse_WhenParameterisExisted_ThenReturnCorrectInfo() async {
        
        let url = CitiBankAPI.url
        let req = URLRequest(url: URL(string: url)!)
        let (data, resp) = try! await sut.request(req: req, config: .default)
        
    }
}
