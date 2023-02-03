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
        let border = CALayer()
        border.backgroundColor = color.cgColor
        switch position {
        case .top:    border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: width)
        case .left:   border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        case .right:  border.frame = CGRect(x: self.frame.width - width, y: 0, width: width, height: self.frame.height)
        case .bottom: border.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
        }
        self.layer.addSublayer(border)
        return border
    }
}
