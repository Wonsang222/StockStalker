//
//  ErrorHandler.swift
//  stockStalker
//
//  Created by WISA Mobile on 3/6/25.
//

import Foundation

struct ErrorHandler {
    let message: Error
    let completion: (() -> Void)?
    
    init(message: Error, completion: (() -> Void)? = nil) {
        self.message = message
        self.completion = completion
    }
}
