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
}
