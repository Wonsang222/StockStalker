//
//  ChartViewModel.swift
//  stockStalker
//
//  Created by Wonsang HWang on 3/7/25.
//

import Foundation

struct ChartEntities {
    let chart: [ChartEntity]
    let interval: String
    
    init(
        chart: [ChartEntity],
        interval: String,
        errorMsg: String?
    ) throws {
        if errorMsg != nil {
            throw NetworkError.dataParse
        }
        
        self.interval = interval
        self.chart = chart
    }
}

struct ChartEntity {
    let timestamp: Int
    let rate: Int
    
    init?(timestamp: Int?, rate: Double?) {
    guard let safeStamp = timestamp, let safeRate = rate
        else { return nil }
        self.timestamp = safeStamp
        self.rate = Int(safeRate)
    }
}
