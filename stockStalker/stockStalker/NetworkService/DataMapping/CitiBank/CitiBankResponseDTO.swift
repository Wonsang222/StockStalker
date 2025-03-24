//
//  CitiBankResponseDTO.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/24/25.
//

import Foundation

struct CitiBankResponseDTO: Decodable {
    let time: String
    let info: [CitiBankInfo]
}

struct CitiBankInfo: Decodable  {
    let country: String?
    let currentRate: String?
    let buy: String?
    let sell: String?
    var updown: String?
}

extension CitiBankInfo {
    func toDomain(target: CitiBankAPI.Countries) throws -> CitiBankEntity {
        let country = target.rawValue
        
    }
}
