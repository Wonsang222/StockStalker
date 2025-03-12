//
//  chartUnderView.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/11/25.
//

import UIKit

// Date
// 1. parsing
// 2. d -> time
// 3. 

final class ChartUnderView: UIView {
    private var chartEntities: ChartEntities? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setEntities(_ entities: ChartEntities?) {
        self.chartEntities = entities
    }
    
    private func configureUI(_ entities: ChartEntities) {
        
    }
    
    private func parseEntities(_ entities: ChartEntities) {
        
        
        for entity in entities.chart {
            
        }
    }
}
