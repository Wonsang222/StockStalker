//
//  UIView+.swift
//  stockStalker
//
//  Created by Wonsang HWang on 3/6/25.
//

import UIKit

extension UIView {
    func safeAddSubView(_ on: UIView) {
        on.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(on)
    }
}
