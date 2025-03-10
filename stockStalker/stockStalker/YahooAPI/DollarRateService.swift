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

enum Countries: String {
    case krw = "KRW=X"
}

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

enum YahooAPI {
    static let baseURL: String = "https://query1.finance.yahoo.com/v8/finance/chart/"
}

enum YahooServices {
    case oneDay
    case aWeek
    case aMonth
    case threeMonths
    case sixMonths
    case aYear
    case threeYears
    case fiveYesars
}

extension YahooServices {
    var getRange: String {
        switch self {
        case .oneDay:
            return Interval.day.createPeriod(1)
        case .aWeek:
            return Interval.week.createPeriod(1)
        case .aMonth:
            return Interval.month.createPeriod(1)
        case .threeMonths:
            return Interval.month.createPeriod(3)
        case .sixMonths:
            return Interval.month.createPeriod(6)
        case .aYear:
            return Interval.year.createPeriod(1)
        case .threeYears:
            return Interval.year.createPeriod(3)
        case .fiveYesars:
            return Interval.year.createPeriod(5)
        }
    }
    
    var getInterval: String {
        switch self {
        case .oneDay:
            return Interval.hour.createPeriod(1)
        case .aWeek:
            return Interval.day.createPeriod(1)
        case .aMonth:
            return Interval.hour.createPeriod(1)
        case .threeMonths:
            return Interval.hour.createPeriod(1)
        case .sixMonths:
            return Interval.hour.createPeriod(1)
        case .aYear:
            return Interval.hour.createPeriod(1)
        case .threeYears:
            return Interval.week.createPeriod(1)
        case .fiveYesars:
            return Interval.week.createPeriod(1)
        }
    }
}
