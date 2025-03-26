//
//  UIView+Rx.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/12/25.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: ChartMainView {
    
    var isLoading: Binder<Bool> {
        return Binder(base) { base, isLoading in
            if isLoading {
                base.showActivityIndicator()
            } else {
                base.removeActivityIndicator()
            }
        }
    }
}

