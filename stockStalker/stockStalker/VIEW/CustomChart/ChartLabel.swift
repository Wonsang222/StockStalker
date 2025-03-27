//
//  ChartLabel.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/27/25.
//

import UIKit

class CustomLabelView: UIView {
    override var intrinsicContentSize: CGSize {
        if let stackView = subviews.first as? UIStackView {
            
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
        return super.intrinsicContentSize // 기본값 (-1.0, -1.0)
    }
}
