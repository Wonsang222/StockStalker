//
//  chartUnderView.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/11/25.
//

import UIKit

final class ChartUnderView: UIView {
    private(set) var chartEntities: ChartEntities
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(_ entities: ChartEntities) {
        
    }
    
    private func parseEntities(_ entities: ChartEntities) {
        for i in entities.chart {
            
        }
    }
}
