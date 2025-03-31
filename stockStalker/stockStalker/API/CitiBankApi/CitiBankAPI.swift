//
//  HanaBankAPI.swift
//  stockStalker
//
//  Created by Wonsang HWang on 3/21/25.
//

import Foundation

enum CitiBankAPI {
    static let url = "https://www.citibank.co.kr"
    static let path = "FxdExrt0100.act"
    
    enum Countries: String {
        case USD = "미국"
        case JPN = "일본"
        case EUR = "유럽"
    }
}
