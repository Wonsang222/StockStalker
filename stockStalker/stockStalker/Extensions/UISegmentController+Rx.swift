//
//  UISegmentController.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/11/25.
//

import UIKit
import RxCocoa
import RxSwift

extension Reactive where Base: UISegmentedControl {
    var action: ControlProperty<String> {
        return base.rx.controlProperty(editingEvents: .valueChanged) { segment in
            return base.titleForSegment(at: base.selectedSegmentIndex)!
        } setter: { _, _ in}
    }
}
