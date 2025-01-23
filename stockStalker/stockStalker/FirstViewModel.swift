//
//  FirstViewModel.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 1/23/25.
//

import UIKit
import RxSwift
import ReactorKit

class FirstViewModel: Reactor {
    
    enum Action {
        case test
    }
    
    enum Mutation {
        case setTest(Int)
    }
    
    struct State {
        
    }
    
    let initialState: State = State()
    
    
}

