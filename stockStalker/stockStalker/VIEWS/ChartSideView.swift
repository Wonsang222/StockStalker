//
//  ChartSideView.swift
//  stockStalker
//
//  Created by Wonsang HWang on 3/5/25.
//

import UIKit

final class ChartSideView: UIStackView {
    private let _axis: NSLayoutConstraint.Axis
    
    init(axis: NSLayoutConstraint.Axis, labelNames: [String]) {
        self._axis = axis
        super.init(frame: .zero)
        configureView(with: labelNames)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(with names: [String]) {
        self.axis = _axis
        self.distribution = .fillEqually
        self.alignment = .center
        
        for name in names {
            let label = UILabel()
            label.text = name
            self.addArrangedSubview(label)
        }
    }
}
