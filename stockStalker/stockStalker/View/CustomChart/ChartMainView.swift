//
//  ChartMainView.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/11/25.
//

import UIKit
import SwiftUI

final class ChartMainView: UIView {
    
    private var chartEntities: ChartEntities? = nil {
        didSet {
            configureData()
        }
    }
    
    private let _chart: ChartView = ChartView(frame: .zero)
    private let _sideView: ChartSideView = ChartSideView(frame: .zero)
        
    private let _segment: UISegmentedControl = {
        let titles = YahooServices.allCases.map { $0.rawValue }
        let seg = UISegmentedControl(items: titles)
        seg.selectedSegmentIndex = 0
        return seg
    }()
    
    var segmentController: UISegmentedControl {
        return _segment
    }
    
    public func setEntities(_ entities: ChartEntities) {
        self.chartEntities = entities
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    private func configureData() {
        self._chart.setEntities(self.chartEntities)
        self._sideView.setEntities(self.chartEntities)
    }
    
    private func configureUI() {
        self.safeAddSubView(_segment)
        self.safeAddSubView(_sideView)
        self.safeAddSubView(_chart)
        
        NSLayoutConstraint.activate([
            _segment.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            _segment.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            _segment.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                        
            _sideView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            _sideView.topAnchor.constraint(equalTo: self.topAnchor),
            _sideView.bottomAnchor.constraint(equalTo: _segment.topAnchor, constant: 8),
            
            _chart.trailingAnchor.constraint(equalTo: _sideView.leadingAnchor),
            _chart.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            _chart.topAnchor.constraint(equalTo: self.topAnchor),
            _chart.bottomAnchor.constraint(equalTo: _segment.bottomAnchor, constant: 8)
        ])
    }
}

#if DEBUG
struct MainViewPreview: PreviewProvider {
    static var previews: some View {
        ChartPreview {
            let v = ChartMainView(frame: .zero)
            v.backgroundColor = .green.withAlphaComponent(0.2)
            return v
        }
        .frame(width: 300, height: 300)
    }
}
#endif
