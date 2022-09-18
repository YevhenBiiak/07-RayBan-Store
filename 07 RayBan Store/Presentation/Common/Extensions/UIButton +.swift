//
//  UIButton +.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import UIKit

extension UIButton {
    static func buttonWithSFImage(name: String, color: UIColor, size: CGFloat, weight: UIImage.SymbolWeight = .regular) -> UIButton {
        guard let image = UIImage(systemName: name) else {
            fatalError("image not found")
        }
        var config = UIButton.Configuration.plain()
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: size, weight: weight)
        config.image = image
        config.buttonSize = .small
        config.baseForegroundColor = color
        
        return UIButton(configuration: config)
    }
}
