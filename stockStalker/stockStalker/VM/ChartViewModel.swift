//
//  ChartViewModel.swift
//  stockStalker
//
//  Created by WISA Mobile on 3/7/25.
//

import Foundation

struct ChartModel {
    let dates: Date
    let rates: Double
}

struct ChartViewModel {
    let charts:[ChartModel]
}
