//
//  ChartLabel.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/27/25.
//

import UIKit

class CustomLabelView: UIView {
    
    func setDateText(_ str: String) {
        let stackView = self.viewWithTag(3) as! UIStackView
        let dateLabel = stackView.viewWithTag(1) as! UILabel
        dateLabel.text = str
    }
    
    func setRateText(_ str: String) {
        let stackView = self.viewWithTag(3) as! UIStackView
        let rateLabel = stackView.viewWithTag(2) as! UILabel
        rateLabel.text = str
    }
    
    func estimateSize() -> CGSize {
        let stackView = self.viewWithTag(3) as! UIStackView
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        stackView.arrangedSubviews.forEach {
            
            if width < $0.intrinsicContentSize.width {
                width = $0.intrinsicContentSize.width
            }
            
            height += $0.intrinsicContentSize.height
        }
        return CGSize(width: width, height: height)
    }
}
