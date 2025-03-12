//
//  Alertable.swift
//  stockStalker
//
//  Created by Wonsang Hwang on 3/12/25.
//

import UIKit

protocol Lodable {}

extension Lodable where Self: UIView {
    
    func showActivityIndicator() {
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
        self.subviews.forEach{ view in
            if let indicator = view as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}

extension UIView: Lodable {}
