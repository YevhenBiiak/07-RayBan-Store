//
//  UIViewController +.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 10.10.2022.
//

import UIKit

extension UIViewController {
    // iOS 13 +
    var statusBarHeight: CGFloat? {
        view.window?.windowScene?.statusBarManager?.statusBarFrame.height
    }
    
    var navigationBarHeight: CGFloat? {
        navigationController?.navigationBar.frame.height
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
