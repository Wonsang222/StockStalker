//
//  ChartSideView.swift
//  stockStalker
//
//  Created by Wonsang HWang on 3/5/25.
//

import UIKit
import SwiftUI

final class ChartSideView: UIStackView {
    
    private var entities: ChartEntities? = nil {
        didSet {
            calculateLabelText()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.distribution = .equalCentering
        self.alignment = .center
    }

    public func setEntities(_ entities: ChartEntities?) {
        self.entities = entities
    }
    
    private func calculateLabelText() {
        guard let entities = entities else { return }
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


#if DEBUG
struct SideViewPreview: PreviewProvider {
    static var previews: some View {
        ChartPreview {
            let v = ChartSideView(frame: .zero)
            v.backgroundColor = .red
            return v
        }
    }
}
#endif

