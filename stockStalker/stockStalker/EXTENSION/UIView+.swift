//
//  UIView+.swift
//  stockStalker
//
//  Created by Wonsang HWang on 3/6/25.
//

import UIKit
import SwiftUI

extension UIView {
    func safeAddSubView(_ on: UIView) {
        on.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(on)
    }
}


struct ChartPreview<View: UIView>: UIViewRepresentable {
    let view: View
    
    init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    func makeUIView(context: Context) -> some UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}

