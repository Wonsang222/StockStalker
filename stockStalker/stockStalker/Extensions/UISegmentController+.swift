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
        return base.rx.controlProperty(editingEvents: .allEditingEvents) { segment in
            return segment.actionForSegment(at: segment.selectedSegmentIndex)!.title
        } setter: { _, _ in}
    }
}
