//
//  CitiBankEntity.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/24/25.
//

import Foundation

struct CitiBankEntity {
    
    enum UpDown: String, CaseIterable {
        case Up = "상승"
        case Down = "하락"
        
        var getIcon: String {
            switch self {
            case .Up:
                return "🔺"
            case .Down:
                return "🔻"
            }
        }
    }
    
    let date: String
    let country: CitiBankAPI.Countries
    let currentRate: String
    let buy: String
    let sell: String
    var updownString: String? = nil
    var updownIcon: String? = nil
    
    init (
        date: String,
        country: CitiBankAPI.Countries,
        currentRate: String,
        buy: String,
        sell: String,
        updown: String?)
    {
        self.date = date
        self.country = country
        self.currentRate = currentRate
        self.buy = buy
        self.sell = sell
        
        if let updown = updown {
            let updownRawString = convertUpdownString(target: updown)
            if updownRawString.hasPrefix("-") {
                updownIcon = UpDown.Down.getIcon
                let dropFirst = updownRawString.dropFirst()
                updownString = String(dropFirst)
            } else {
                updownIcon = UpDown.Up.getIcon
                updownString = updownRawString
            }
        }
    }
}

fileprivate extension CitiBankEntity {
    func convertUpdownString(target: String) -> String {
        let pattern = "^-?[0-9]+(\\.[0-9]{1,2})?$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(target.startIndex..<target.endIndex, in: target)
        guard let match = regex.firstMatch(in: target, range: range) else { return "시간 정보가 없습니다" }
        let matchedRange = Range(match.range, in: target)!
        return String(target[matchedRange])
    }
}
