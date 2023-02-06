//
//  UIFont +.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import UIKit

extension UIFont {

    struct Oswald {
        static var bold: UIFont { UIFont(name: "Oswald-Bold", size: 16)! }
        static var medium: UIFont { UIFont(name: "Oswald-Medium", size: 16)! }
        static var regular: UIFont { UIFont(name: "Oswald-Regular", size: 16)! }
        static var light: UIFont { UIFont(name: "Oswald-Light", size: 16)! }
    }
    
    struct Lato {
        static var bold: UIFont { UIFont(name: "Lato-Bold", size: 16)! }
        static var black: UIFont { UIFont(name: "Lato-Black", size: 16)! }
        static var regular: UIFont { UIFont(name: "Lato-Regular", size: 16)! }
        static var light: UIFont { UIFont(name: "Lato-Light", size: 16)! }
    }
}
