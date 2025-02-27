//
//  DollarRateService.swift
//  stockStalker
//
//  Created by WISA Mobile on 2/26/25.
//

import Foundation

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

