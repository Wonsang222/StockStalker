//
//  UIViewController+.swift
//  stockStalker
//
//  Created by Wonsang HWang on 3/6/25.
//

import UIKit
import SwiftUI

protocol Reusable {}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UIViewController: Reusable {}

extension UIStoryboard {
    func createVC<T>(ofType type: T.Type = T.self) -> T where T: UIViewController {
        guard let vc = instantiateViewController(withIdentifier: type.reuseID) as? T else {
            fatalError()
        }
        return vc
    }
}

extension UIViewController {
    
    func showError(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "확인", style: .cancel) { _ in
            completion?()
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.tintColor = .gray
        self.view.safeAddSubView(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    func removeActivityIndicator() {
        self.view.subviews.forEach{ view in
            if let indicator = view as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}

struct UIViewControllerPreview<T: UIViewController>: UIViewControllerRepresentable {
    let vc: T
    
    init(_ builder: @escaping () -> T) {
        vc = builder()
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {    }
}
