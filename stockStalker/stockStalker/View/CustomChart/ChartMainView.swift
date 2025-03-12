//
//  ChartMainView.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/11/25.
//

import UIKit

final class ChartMainView: UIView {
    
    private var chartEntities: ChartEntities? = nil {
        didSet {
            configureData()
        }
    }
    
    private let _chart: ChartView = ChartView(frame: .zero)
        
    private let _segment: UISegmentedControl = {
        let seg = UISegmentedControl()
        let actions = YahooServices
                        .allCases
                        .map { UIAction(title: $0.rawValue) { action in   }}
        
        for (idx,action) in actions.enumerated() {
            seg.setAction(action, forSegmentAt: idx)
        }
        seg.selectedSegmentIndex = 0
        return seg
    }()
    
    private let _sideView: ChartSideView = ChartSideView(frame: .zero)
    private let _underView: ChartUnderView = ChartUnderView(frame: .zero)
    
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
        self._underView.setEntities(self.chartEntities)
    }
    
    private func configureUI() {
        self.safeAddSubView(_segment)
        self.safeAddSubView(_underView)
        self.safeAddSubView(_sideView)
        self.safeAddSubView(_chart)
        
        NSLayoutConstraint.activate([
            _segment.leadingAnchor.constraint(equalTo: self.leftAnchor),
            _segment.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            _segment.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            _underView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            _underView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            _underView.bottomAnchor.constraint(equalTo: _segment.topAnchor, constant: 8),
            
            _sideView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            _sideView.topAnchor.constraint(equalTo: self.topAnchor),
            _sideView.bottomAnchor.constraint(equalTo: _underView.topAnchor, constant: 8),
            
            _chart.trailingAnchor.constraint(equalTo: _sideView.leadingAnchor),
            _chart.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            _chart.topAnchor.constraint(equalTo: self.topAnchor),
            _chart.bottomAnchor.constraint(equalTo: _underView.bottomAnchor, constant: 8)
        ])
    }
}



#if canImport(SwiftUI)
import SwiftUI



#endif

