//
//  WarningView.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 01.03.2023.
//

import UIKit

extension UIViewController {
    
    func showWarning(with text: String) {
        // create views
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = .appRed

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .appWhite
        label.numberOfLines = 0
        label.text = text
        
        // configure layout
        content.addSubview(label)
        view.addSubview(content)
        
        label.topAnchor.constraint(equalTo: content.topAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -8).isActive = true
        label.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 8).isActive = true
        label.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -8).isActive = true
        
        content.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        content.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        content.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // layout content subviews
        content.layoutIfNeeded()
        content.topConstraint?.constant = -content.frame.height
        
        // animate
        content.alpha = 0
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            content.alpha = 1
            content.topConstraint?.constant = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 4) {
                content.alpha = 0
                content.topConstraint?.constant = -content.frame.height
                self.view.layoutIfNeeded()
            } completion: { _ in
                content.removeFromSuperview()
            }
        }
    }
}
