//
//  MoneyRateViewModel.swift
//  stockStalker
//
//  Created by WISA Mobile on 3/6/25.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit

final class MoneyRateViewModel: Reactor {
    
    enum Action {
        case tapBtn(String)
    }
    
    enum Mutation {
        case fetchFinancialInfo
        case setLoading(Bool)
        case setAlertMessage(ErrorHandler)
    }
    
    struct State {
        @Pulse var rates: [Double] = []
    }
    
    let initialState: State = State()
    
    
}

