//
//  APIEndpoints.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/10/25.
//

import Foundation

struct APIEndpoints {
    static func getYahoo(with dto: YahooRequestDTO) -> EndPoint<ChartResponseDTO> {
        return EndPoint(path: dto.country,
                        method: .get,
                        queryEncodable: dto,
                        header: ["UserAgent" : "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36"],
                        responseDecoder: EntitiyTypeResponseDecoder())
    }
    
    static func getCitiBank(with dto: CitiBankRequestDTO) -> EndPoint<CitiBankResponseDTO> {
        return EndPoint(path: CitiBankAPI.path,
                        method: .get,
                        queryEncodable: nil,
                        header: [:],
                        responseDecoder: EntitiyTypeResponseDecoder())
    }
}
