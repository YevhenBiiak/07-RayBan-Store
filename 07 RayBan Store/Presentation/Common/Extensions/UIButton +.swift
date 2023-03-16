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
    
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping () -> Void) {
        let action = UIAction { _ in
            closure()
        }
        addAction(action, for: controlEvents)
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(image, for: state)
    }
}
