//
//  ChartMainView+.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/12/25.
//

import RxCocoa
import RxSwift

extension Reactive where Base: ChartMainView {
    var segment: ControlProperty<String> {
        return base.segmentController.rx.action
    }
    
    var drawChart: Binder<ChartEntities> {
        return Binder(base) { mainView, entities in
            mainView.setEntities(entities)
        }
    }
}
