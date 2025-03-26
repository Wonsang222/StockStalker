//
//  Observable+Ext.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/25/25.
//

import RxSwift
import RxCocoa

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            Driver.empty()
        }
    }
    
    func catchErrorJustComplete() -> Observable<Element> {
        return self.catch { _ in
            Observable.empty()
        }
    }
}
