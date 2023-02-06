//
//  UIViewController +.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 10.10.2022.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UINavigationController {
    
    var navigationBarHeight: CGFloat? {
        navigationController?.navigationBar.frame.height
    }
}
