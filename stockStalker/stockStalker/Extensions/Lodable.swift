//
//  Alertable.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/12/25.
//

import UIKit

protocol Loadable {}

extension Loadable where Self: ChartMainView {
    
    func showActivityIndicator() {
        
        for subview in subviews {
            if let _ = subview as? UIActivityIndicatorView {
                return
            }
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.tintColor = .gray
        self.safeAddSubView(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func removeActivityIndicator() {
        for subView in subviews {
            if let indicator = subView as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
                break
            }
        }
    }
}

extension ChartMainView: Loadable {}
