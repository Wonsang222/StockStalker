//
//  UIViewController+Rx.swift
//  stockStalker
//
//  Created by WISA Mobile on 3/6/25.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    
    var error: Binder<Error> {
        return Binder(base) { vc, err in
            vc.showError(message: err.localizedDescription)
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
