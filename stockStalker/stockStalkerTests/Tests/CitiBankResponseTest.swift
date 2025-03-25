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
    var decoder: ResponseDecoder!
    
    override func setUp() async throws {
        sut = MockSessionManager()
        decoder = MockResponseDecoder()
    }
    
    override func tearDown() async throws {
        sut = nil
        decoder = nil
    }
    
    func testParseCitiBankResponse_WhenParameterisExisted_ThenParsedWithoutError() async {
        
        let url = CitiBankAPI.url
        let req = URLRequest(url: URL(string: url)!)
        let (data, _) = try! await sut.request(req: req, config: .default)
        
        do {
            let _: CitiBankResponseDTO = try decoder.decode(data)
        } catch {
            XCTFail()
        }
    }
}
