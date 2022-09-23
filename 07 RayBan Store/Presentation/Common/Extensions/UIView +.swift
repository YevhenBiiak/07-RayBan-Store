//
//  UIView +.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 23.09.2022.
//

import UIKit

extension UIView {
    enum BorderPosition { case top, left, right, bottom }
    func addBorder(atPosition position: [BorderPosition], color: UIColor, width: CGFloat) {
        position.forEach { position in
            addBorder(atPosition: position, color: color, width: width)
        }
    }
    func addBorder(atPosition position: BorderPosition, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        switch position {
        case .top: border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        case .left: border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .right: border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        case .bottom: border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        }
        self.layer.addSublayer(border)
    }
}
