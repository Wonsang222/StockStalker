//
//  ChartMainView.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/11/25.
//

import UIKit
import SwiftUI

// label font -> size

// chartMainView -> controlEvent -> 

final class ChartMainView: UIView {
    
    private(set) var chartEntities: ChartEntities
    
    private let _chart: ChartView = ChartView(frame: .zero)
    
    private let _segment: UISegmentedControl = {
        let seg = UISegmentedControl()
        let actions = YahooServices.allCases
            .map { UIAction(title: $0.rawValue) { action in   }}
        for (idx,action) in actions.enumerated() {
            seg.setAction(action, forSegmentAt: idx)
        }
        seg.selectedSegmentIndex = 0
        return seg
    }()
    
    private let _sideView: ChartSideView!
    private let _underView: UIView = UIView(frame: .zero)
    
    init(chartEntities: ChartEntities?) {
        if let chartEntities = chartEntities {
            self.chartEntities = chartEntities
        }
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
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


