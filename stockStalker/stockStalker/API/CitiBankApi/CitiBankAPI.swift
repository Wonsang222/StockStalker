//
//  HanaBankAPI.swift
//  stockStalker
//
//  Created by Wonsang HWang on 3/21/25.
//

import Foundation

enum CitiBankAPI {
    static let url = "https://www.citibank.co.kr/FxdExrt0100.act"
    
    enum Countries: String {
        case USD = "USD"
        case JPN = "JPN"
        case EUR = "EUR"
    }
}
