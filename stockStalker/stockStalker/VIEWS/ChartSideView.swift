//
//  ChartSideView.swift
//  stockStalker
//
//  Created by Wonsang HWang on 3/5/25.
//

import UIKit

final class ChartSideView: UIStackView {
    
    private(set) var entities: ChartEntities {
        didSet {
            calculateLabelText()
        }
    }
    
    init( entities: ChartEntities) {
        self.axis = .vertical
        self.distribution = .equalCentering
        self.alignment = .center
        super.init(frame: .zero)
    }
    
    private func calculateLabelText() {
        let firstValue = entities.chart[0].rate
        let maxMin = entities.chart.reduce((firstValue, firstValue)) { partialResult, current in
            let max = current.rate > partialResult.0 ? current.rate : partialResult.0
            let min = current.rate < partialResult.1 ? current.rate : partialResult.1
            return (max,min)
        }
        let maxMinGapRatio = Int(Double(maxMin.0 - maxMin.1) * 0.2)
        
        (0...4).forEach { idx in
            let label = UILabel()
            let value = (maxMinGapRatio * idx) + maxMin.1
            label.text = "\(value)"
            self.addArrangedSubview(label)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
