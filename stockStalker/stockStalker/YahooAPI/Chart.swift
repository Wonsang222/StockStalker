//
//  Chart.swift
//  stockStalker
//
//  Created by WISA Mobile on 3/5/25.
//

import Foundation

// MARK: - Chart
struct Chart: Decodable {
    let result: [Result]?
    let error: JSONNull?
}

// MARK: - Result
struct Result: Decodable {
    let timestamp: [Int]?
    let indicators: Indicators?
}

// MARK: - Indicators
struct Indicators: Decodable {
    let quote: [Quote]?
    let adjclose: [Adjclose]?
}

// MARK: - Adjclose
struct Adjclose: Decodable {
    let adjclose: [Double]?
}

// MARK: - Quote
struct Quote: Decodable {
    let low, quoteOpen, close, high: [Double]?
    let volume: [Int]?

    enum CodingKeys: String, CodingKey {
        case low
        case quoteOpen = "open"
        case close, high, volume
    }
}

// MARK: - CurrentTradingPeriod
struct CurrentTradingPeriod: Decodable {
    let pre, regular, post: Post?
}

// MARK: - Post
struct Post: Decodable {
    let timezone: String?
    let start, end, gmtoffset: Int?
}

// MARK: - Encode/decode helpers

class JSONNull: Decodable {
    public let code: String
    public let description: String
    
    public init(code: String, description: String) {
        self.code = code
        self.description = description
    }
}
