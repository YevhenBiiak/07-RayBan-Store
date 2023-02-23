//
//  UIView +.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 23.09.2022.
//

import UIKit

extension UIView {
    
    enum BorderPosition { case top, left, right, bottom }
    
    func addBorders(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    @discardableResult
    func addBorder(at position: BorderPosition, color: UIColor, width: CGFloat) -> CALayer {
        
        let border = UIView()
        border.layer.backgroundColor = color.cgColor
        border.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(border)
        
        switch position {
        case .top:
            border.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            border.topAnchor.constraint(equalTo: topAnchor).isActive = true
            border.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            border.bottomAnchor.constraint(equalTo: topAnchor, constant: width).isActive = true
        case .left:
            border.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            border.topAnchor.constraint(equalTo: topAnchor).isActive = true
            border.rightAnchor.constraint(equalTo: leftAnchor, constant: width).isActive = true
            border.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        case .right:
            border.leftAnchor.constraint(equalTo: rightAnchor, constant: -width).isActive = true
            border.topAnchor.constraint(equalTo: topAnchor).isActive = true
            border.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            border.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        case .bottom:
            border.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            border.topAnchor.constraint(equalTo: bottomAnchor, constant: -width).isActive = true
            border.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            border.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
        
        return border.layer
    }
}
