//
//  CAShapeLayer+.swift
//  stockStalker
//
//  Created by Wonsang HWang on 3/13/25.
//

import UIKit

final class TaggedLayer: CAShapeLayer {
    let tag: Int
    
    init(tag: Int) {
        self.tag = tag
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
