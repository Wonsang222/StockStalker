//
//  UIViewController+Rx.swift
//  stockStalker
//
//  Created by Wonsang HWang on 3/6/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    var error: Binder<ErrorHandler> {
        return Binder(base) { vc, err in
            vc.showError(message: err.message.localizedDescription, completion: err.completion)
        }
    }
    
    var isLoading: Binder<Bool> {
        return Binder(base) { vc, bool in
            if bool {
                vc.showActivityIndicator()
            } else {
                vc.removeActivityIndicator()
            }
        }
    }
}
