//
//  CitiBankResponseDTO.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/24/25.
//

import Foundation

struct CitiBankResponseDTO {
    let time: String
    let info: [CitiBankInfo]
}

struct CitiBankInfo  {
    let country: String
    let currentRate: String
    let buy: String
    let sell: String
}
