//
//  UIImage +.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.10.2022.
//

import UIKit

extension UIImage {
    
    convenience init?(systemName: String, pointSize: CGFloat, weight: UIImage.SymbolWeight, paletteColors: [UIColor] = []) {
        let sizeConfig = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        let colorConfig = UIImage.SymbolConfiguration(paletteColors: paletteColors)
        let config = sizeConfig.applying(colorConfig)
        
        self.init(systemName: systemName, withConfiguration: config)
    }
    
    convenience init?(named: String, pointSize: CGFloat, weight: UIImage.SymbolWeight, paletteColors: [UIColor] = []) {
        let config = UIImage.SymbolConfiguration.unspecified
            .applying(UIImage.SymbolConfiguration(paletteColors: paletteColors))
            .applying(UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold))
        
        self.init(named: named, in: nil, with: config)
    }
    
    var aspectRation: CGFloat {
        size.width / size.height
    }
}
