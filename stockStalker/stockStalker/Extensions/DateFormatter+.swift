//
//  DateFormatter+.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/20/25.
//

import Foundation

extension DateFormatter {
    func convertUNIXStamp(_ stamp: Int) -> String {
        let interval = TimeInterval(truncating: stamp as NSNumber)
        let date = Date(timeIntervalSince1970: interval)
        return self.string(from: date)
    }
}
