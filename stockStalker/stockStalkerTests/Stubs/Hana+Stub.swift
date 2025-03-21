//
//  Hana+Stub.swift
//  stockStalkerTests
//
//  Created by Wonsang Hwang on 3/21/25.
//

import Foundation
@testable import stockStalker

struct HanaBankResponseStub {
    static func getURL() -> String {
        return stockStalker.HanaBankAPI.url
    }
}
