//
//  YahooRequestDTO.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/10/25.
//

import Foundation

struct YahooRequestDTO: Encodable {
    let country: String
    let interval: String
    let range: String
    
    init(country: String = YahooAPI.Countries.krw.rawValue,
         interval: String,
         range: String)
    {
        self.country = country
        self.interval = interval
        self.range = range
    }
    
    private enum CodingKeys: CodingKey {
        case interval
        case range
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.interval, forKey: .interval)
        try container.encode(self.range, forKey: .range)
    }
}
