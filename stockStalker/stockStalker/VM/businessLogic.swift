//
//  chartUnderView.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/11/25.
//

import UIKit
/*
 
 비즈니스 로직 -> ViewModel로 이동 예정
 이유 -> 여기서 에러 발생 -> 다시 밖으로 보내는게 어렵다
 

 무조건 4개
 
 1일 -> 2시간
 1주 -> 2일
 1달 -> 주
 3달 -> 달
 6달 -> 2달
 1년 -> 3개월
 3년 -> 1년
 5년 -> 1년
 
 * 기간의 시작 부분이 x
 순회 -> parsing ->  기준 filter -> set -> 중복제거
 

 
 */

fileprivate let MAXIMUM: Int = 5

final class ChartUnderView: UIView {
    
    private var chartEntities: ChartEntities? = nil
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년-MM월-dd일-HH시"
        return formatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func filterRegularExpressionByPolicy(entities: ChartEntities) -> String {
        let periodInterval = entities.interval
        let period = periodInterval[periodInterval.startIndex]
        let secondIdx = periodInterval.index(after: periodInterval.startIndex)
        let interval = String(periodInterval[secondIdx..<periodInterval.endIndex])
        
        var predicate: String = ""
        
        switch YahooAPI.Interval(rawValue: interval)! {
        case .day:
            predicate = "\\d{2}시"
        case .hour:
            fatalError()
        case .min:
            fatalError()
        case .week:
            predicate = "\\d{2}일"
        case .month:
            predicate = "\\d{2}일"
        case .year:
            if period != "1" {
                predicate = "\\d{2}년"
            }
            predicate = "\\d{2}월"
        }
        return predicate
    }
    
    private func filterDateStringByRegExp(entities: ChartEntities, date: String) -> String {
        let filteredReg = filterRegularExpressionByPolicy(entities: entities)
        let regex = try! NSRegularExpression(pattern: filteredReg)
        let range = NSRange(date.startIndex..<date.endIndex, in: date)
        let match = regex.firstMatch(in: date, range: range)!
        let matchedRange = Range(match.range, in: date)!
        let result = String(date[matchedRange])
        return result
    }
    
    private func parseEntities(_ entities: ChartEntities) -> [CGRect] {
        let locationXY = [CGRect]()
        let entityX = self.bounds.width / entities.chart.count.makeCGFloat
        
        let dates = entities.chart
            .map { entitiy in
                let interval = TimeInterval(truncating: entitiy.timestamp as NSNumber)
                let date = Date(timeIntervalSince1970: interval)
                return dateFormatter.string(from: date)
            }
            .map { filterDateStringByRegExp(entities: entities, date: $0) }
        
        for (idx,date) in dates.enumerated() {
            
        }
        return locationXY
    }
}

