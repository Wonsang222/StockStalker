//
//  ChartViewModel.swift
//  stockStalker
//
//  Created by Wonsang HWang on 3/7/25.
//

import Foundation

struct ChartEntities {
    let chart: [ChartEntity]
    let interval: Character
    
    init(
        chart: [ChartEntity],
        interval: String,
        errorMsg: String?
    ) throws {
        if errorMsg != nil {
            throw NetworkError.dataParse
        }
        
        var intervalCopy = interval
        self.interval = intervalCopy.popLast()!
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
