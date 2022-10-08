//
//  UIImage +.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.10.2022.
//

import UIKit

extension UIImage {
    convenience init?(systemName: String, tintColor: UIColor, pointSize: CGFloat, weight: UIImage.SymbolWeight) {
        let sizeConfig = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        let colorConfig = UIImage.SymbolConfiguration(hierarchicalColor: tintColor)
        let config = sizeConfig.applying(colorConfig)
        
        self.init(systemName: systemName, withConfiguration: config)
    }
}
