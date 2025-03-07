//
//  Chart.swift
//  stockStalker
//
//  Created by WISA Mobile on 3/5/25.
//

import Foundation

struct ChartResponseDTO: Decodable {
    let chart: ChartDTO
}

extension ChartResponseDTO {
    
    struct ChartDTO: Decodable {
        let result: [ChartResultDTO]?
        let error: String?
    }
    
    struct ChartResultDTO: Decodable {
        let timestamp: [Int]?
        let indicators: IndicatorsDTO
    }

    struct IndicatorsDTO: Decodable {
        let quote: [QuoteDTO]
    }

    struct QuoteDTO: Decodable {
        let close: [Double?]
    }
}

extension ChartResponseDTO {
    func getErrorString() -> String? {
        return chart.error
    }
    
    var getDates: [Int]? {
        return chart.result.
    }
}

extension ChartResponseDTO.ChartDTO {
    
}

extension ChartResponseDTO.ChartResultDTO {
    var getDates: [Int]? {
        return timestamp
    }
}

extension ChartResponseDTO.IndicatorsDTO {
    
}

extension ChartResponseDTO.QuoteDTO {
    
}
