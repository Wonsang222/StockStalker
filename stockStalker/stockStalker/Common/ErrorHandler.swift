//
//  ErrorHandler.swift
//  stockStalker
//
//  Created by Wonsang HWang on 3/6/25.
//

import Foundation

struct ErrorHandler {
    let message: String
    let completion: (() -> Void)?
    
    init(message: String, completion: (() -> Void)? = nil) {
        self.message = message
        self.completion = completion
    }
}
