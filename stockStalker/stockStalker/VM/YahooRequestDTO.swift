//
//  YahooRequestDTO.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/10/25.
//

import Foundation

struct YahooRequestDTO: Encodable {
    let interval: String
    let range: String
}
