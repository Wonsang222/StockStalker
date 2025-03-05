//
//  DollarRateService.swift
//  stockStalker
//
//  Created by WISA Mobile on 2/26/25.
//

import Foundation

// 1년  https://query1.finance.yahoo.com/v8/finance/chart/KRW=X?range=1y&interval=1d
// 3년  https://query1.finance.yahoo.com/v8/finance/chart/KRW=X?range=3y&interval=1wk
// 5년  https://query1.finance.yahoo.com/v8/finance/chart/KRW=X?range=5y&interval=1mo

enum Countries: String {
    case krw = "KRW=X"
}

enum Interval: String {
    case min = "m"
    case day = "d"
    case week = "wk"
    case month = "mo"
    case year = "y"
    
    func createPeriod(_ period: Int) -> String {
        return "\(period)" + self.rawValue
    }
}

enum YahooAPI {
    static let baseURL: String = "https://query1.finance.yahoo.com/v8/finance/chart/"
}

