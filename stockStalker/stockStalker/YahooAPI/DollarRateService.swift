//
//  DollarRateService.swift
//  stockStalker
//
//  Created by Wonsang HWang on 2/26/25.
//

import Foundation

// 1일 https://query1.finance.yahoo.com/v8/finance/chart/KRW=X?range=1d&interval=1h
// 7일 https://query1.finance.yahoo.com/v8/finance/chart/KRW=X?range=7d&interval=1d
// 1달 https://query1.finance.yahoo.com/v8/finance/chart/KRW=X?range=1mo&interval=1d
// 3달 https://query1.finance.yahoo.com/v8/finance/chart/KRW=X?range=3mo&interval=1d
// 6달 https://query1.finance.yahoo.com/v8/finance/chart/KRW=X?range=6mo&interval=1d
// 1년  https://query1.finance.yahoo.com/v8/finance/chart/KRW=X?range=1y&interval=1d
// 3년  https://query1.finance.yahoo.com/v8/finance/chart/KRW=X?range=3y&interval=1wk
// 5년  https://query1.finance.yahoo.com/v8/finance/chart/KRW=X?range=5y&interval=1wk

enum YahooAPI {
    static let baseURL: String = "https://query1.finance.yahoo.com/v8/finance/chart/"
    
    enum Interval: String {
        case hour = "h"
        case min = "m"
        case day = "d"
        case week = "wk"
        case month = "mo"
        case year = "y"
        
        func createPeriod(_ period: Int) -> String {
            return "\(period)" + self.rawValue
        }
    }
    
    enum Countries: String {
        case krw = "KRW=X"
    }
}

enum YahooServices: String, CaseIterable {
    case oneDay = "1일"
    case aWeek = "1주"
    case aMonth = "1달"
    case threeMonths = "3달"
    case sixMonths = "6달"
    case aYear = "1년"
    case threeYears = "3년"
    case fiveYesars = "5년"
}

extension YahooServices {
    var getRange: String {
        switch self {
        case .oneDay:
            return YahooAPI.Interval.day.createPeriod(1)
        case .aWeek:
            return YahooAPI.Interval.week.createPeriod(1)
        case .aMonth:
            return YahooAPI.Interval.month.createPeriod(1)
        case .threeMonths:
            return YahooAPI.Interval.month.createPeriod(3)
        case .sixMonths:
            return YahooAPI.Interval.month.createPeriod(6)
        case .aYear:
            return YahooAPI.Interval.year.createPeriod(1)
        case .threeYears:
            return YahooAPI.Interval.year.createPeriod(3)
        case .fiveYesars:
            return YahooAPI.Interval.year.createPeriod(5)
        }
    }
    
    var getInterval: String {
        switch self {
        case .oneDay:
            return YahooAPI.Interval.hour.createPeriod(1)
        case .aWeek:
            return YahooAPI.Interval.day.createPeriod(1)
        case .aMonth:
            return YahooAPI.Interval.hour.createPeriod(1)
        case .threeMonths:
            return YahooAPI.Interval.hour.createPeriod(1)
        case .sixMonths:
            return YahooAPI.Interval.hour.createPeriod(1)
        case .aYear:
            return YahooAPI.Interval.hour.createPeriod(1)
        case .threeYears:
            return YahooAPI.Interval.week.createPeriod(1)
        case .fiveYesars:
            return YahooAPI.Interval.week.createPeriod(1)
        }
    }
}
