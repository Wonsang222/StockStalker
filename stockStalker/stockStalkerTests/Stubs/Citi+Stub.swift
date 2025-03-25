//
//  Hana+Stub.swift
//  stockStalkerTests
//
//  Created by Wonsang Hwang on 3/21/25.
//

import Foundation
@testable import stockStalker

struct CitiBankResponseStub {
    static func getURL() -> String {
        return stockStalker.CitiBankAPI.url
    }

    static func getResultString() -> String {
    return """
    {"info":[{"country":"중국","buy":"217.54","sell":"187.41","updown":"상승0.55","currentRate":"202.41"},{"country":"유럽","buy":"1,621.23","sell":"1,552.42","updown":"상승1.83","currentRate":"1,586.77"},{"country":"일본","buy":"996.37","sell":"958.27","updown":"하락-4.19","currentRate":"977.29"},{"country":"미국","buy":"1,497.76","sell":"1,441.33","updown":"상승4","currentRate":"1,469.50"}],"time":"(조회시간 : 2025-03-25 08:16:57)"}
    """
    }
}
