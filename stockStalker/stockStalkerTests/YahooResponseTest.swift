//
//  stockStalkerTests.swift
//  stockStalkerTests
//
//  Created by Wonsang Hwang on 3/8/25.
//

import XCTest
@testable import stockStalker

class YahooResponseTest: XCTestCase {
    
    var sut: ResponseDecoder!
    var response: Data!
    
    override func setUpWithError() throws {
        sut = MockResponseDecoder()
        response = YahooResponse.getData()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        response = nil
    }
    
    func testParsing_WhenDecoded_NoErrorReturned() {
        do {
            let _: ChartResponseDTO = try sut.decode(response)
        } catch {
            XCTFail()
        }
    }
    
    func testToDomain_WhenParsed_NoErrorReturned() {
        let target: ChartResponseDTO = try! sut.decode(response
        )
        do {
           _ = try target.toDomain()
        } catch {
            XCTFail()
        }
    }
}
