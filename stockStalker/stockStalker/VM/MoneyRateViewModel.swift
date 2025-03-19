//
//  MoneyRateViewModel.swift
//  stockStalker
//
//  Created by Wonsang HWang on 3/6/25.
//

import RxSwift
import ReactorKit
import Foundation

// logger 추가

final class MoneyRateViewModel: Reactor {
    private let _networkService: RxDataTransferWrapperType
    
    init(_networkService: RxDataTransferWrapperType) {
        self._networkService = _networkService
    }
    
    enum Action {
        case tapBtn(YahooServices)
//        case fetchHanaBankInfo
    }
    
    enum Mutation {
        case fetchFinancialInfo(ChartEntities)
        case setLoading(Bool)
        case setAlertMessage(ErrorHandler)
    }
    
    struct State {
        @Pulse var rates: ChartEntities?
        @Pulse var error: ErrorHandler?
        @Pulse var isLoading: Bool = false
        @Pulse var date: Date? = nil
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tapBtn(let yahooService):
            Observable.concat([
                Observable.just(.setLoading(true)),
                _networkService.request(convertToEndpoint(with: yahooService))
                    .map { try Mutation.fetchFinancialInfo($0.toDomain()) }
                    .asObservable()
                    .take(until: self.action.filter(Action.isNewFetching))
                    .catch(self.createErrorHandler)
                ,Observable.just(.setLoading(false))
            ])
        }
    }   
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .fetchFinancialInfo(let entities):
            state.rates = entities
        case .setAlertMessage(let errorHandler):
            state.error = errorHandler
        case .setLoading(let bool):
            state.isLoading = bool
        }
        return state
    }
}

extension MoneyRateViewModel {
    private func convertToEndpoint(with yahoo: YahooServices) -> EndPoint<ChartResponseDTO> {
        let requestDTO = YahooRequestDTO(interval: yahoo.getInterval, range: yahoo.getRange)
        let endPoint = APIEndpoints.getYahoo(with: requestDTO)
        return endPoint
    }
    
    private func createErrorHandler(with error: any Error) -> Observable<Mutation> {
        if let networkError = error as? NetworkError {
            if case .cancellation = networkError {
                return Observable.empty()
            } else {
                let handler = ErrorHandler(message: networkError)
                return Observable.just(.setAlertMessage(handler))
            }
        }
        return Observable.empty()
    }
}

extension MoneyRateViewModel.Action {
    static func isNewFetching(with action: MoneyRateViewModel.Action) -> Bool {
        if case .tapBtn = action {
            return true
        }
        return false
    }
}
