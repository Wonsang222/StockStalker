//
//  CitiBankEntity.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/24/25.
//

import Foundation

struct CitiBankEntity {
    let date: Date
    let country: CitiBankAPI.Countries
    let currentRate: String
    let buy: String
    let sell: String
    var updown: String? = nil
    var updownIcon: Bool? = nil
    
    init(date: Date,
         country: CitiBankAPI.Countries,
         currentRate: String,
         buy: String,
         sell: String,
         updown: String? = nil,
         updownIcon: Bool? = nil
    ) {
        self.date = date
        self.country = country
        self.currentRate = currentRate
        self.buy = buy
        self.sell = sell
        self.updown = updown
        self.updownIcon = updownIcon
    }
}
