//
//  CitiBankResponseDTO.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/24/25.
//

import Foundation

struct CitiBankResponseDTO: Decodable {
    let time: String?
    let info: [CitiBankInfo]
}

struct CitiBankInfo: Decodable  {
    let country: String?
    let currentRate: String?
    let buy: String?
    let sell: String?
    var updown: String?
}

extension CitiBankResponseDTO {
    func toDomain(target: CitiBankAPI.Countries) -> CitiBankEntity {
        let errorMsg = "서버오류"
        let targetNation = info.filter { $0.country == target.rawValue }.first
        
        return CitiBankEntity(date: DateFormatter().getDateString(dateString: time) ?? errorMsg,
                              country: target,
                              currentRate: targetNation?.currentRate ?? errorMsg,
                              buy: targetNation?.buy ?? errorMsg,
                              sell: targetNation?.sell ?? errorMsg,
                              updown: targetNation?.updown)
    }
}

fileprivate extension DateFormatter {
    func getDateString(dateString: String?) -> String? {
        guard let dateString = dateString else { return nil }
        let pattern = "\\d{2}:\\d{2}"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(dateString.startIndex..<dateString.endIndex, in: dateString)
        guard let match = regex.firstMatch(in: dateString, range: range) else { return "시간 정보가 없습니다" }
        let matchedRange = Range(match.range, in: dateString)!
        return String(dateString[matchedRange])
    }
}
