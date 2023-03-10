//
//  UIColor +.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import UIKit

extension UIColor {
    static var appWhite: UIColor {
       UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
    }
    static var appLightGray: UIColor {
        UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1)
    }
    static var appGray: UIColor {
        UIColor(red: 226 / 255, green: 226 / 255, blue: 226 / 255, alpha: 1)
    }
    static var appDarkGray: UIColor {
        UIColor(red: 99 / 255, green: 99 / 255, blue: 99 / 255, alpha: 1)
    }
    static var appBlack: UIColor {
        UIColor(red: 31 / 255, green: 31 / 255, blue: 36 / 255, alpha: 1)
    }
    static var appRed: UIColor {
        UIColor(red: 222 / 255, green: 10 / 255, blue: 1 / 255, alpha: 1)
    }
}

extension UIColor {
    var hexString: String {
        cgColor.components!
            .prefix(3)
            .map { String(format: "%02lX", Int($0 * 255)) }
            .reduce("#", +)
    }
}
