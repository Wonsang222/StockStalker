//
//  Chart.swift
//  stockStalker
//
//  Created by Wonsang HWang on 3/5/25.
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
        let timestamp: [Int?]?
        let indicators: IndicatorsDTO
        let meta: MetaDTO
    }
    
    
    struct MetaDTO: Decodable {
        let range: String
        let regularMarketTime: Int
    }
    
    struct IndicatorsDTO: Decodable {
        let quote: [QuoteDTO]
    }

    struct QuoteDTO: Decodable {
        let close: [Double?]?
    }
}

extension ChartResponseDTO.ChartResultDTO {
    func toDomain() throws -> [ChartEntity] {
        
        guard let timestamp = timestamp,
              let quoteRates = indicators.quote[0].close
        else {
            throw NetworkError.dataParse
        }

        var charEntities = [ChartEntity?]()
        zip(timestamp, quoteRates).forEach{ charEntities.append(ChartEntity(timestamp: $0, rate: $1)) }
        return charEntities.compactMap{ $0 }
    }
}

extension ChartResponseDTO {
    func toDomain() throws -> ChartEntities {
        guard let results = chart.result?[0] else {
            throw NetworkError.api
        }
        
        let data = try results.toDomain()
        return try ChartEntities(chart: data,
                                 interval: results.meta.range,
                                 standardTime: results.meta.regularMarketTime,
                                 errorMsg: chart.error)
    }
}
