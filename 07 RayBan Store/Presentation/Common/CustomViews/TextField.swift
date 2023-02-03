//
//  TextField.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 01.02.2023.
//

import UIKit

class TextField: UITextField {
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: textRect(forBounds: bounds))
        label.text = (placeholder ?? "") + "*"
        label.font = font
        label.sizeToFit()
        return label
    }()
    
    var isRequiredTextEntry: Bool = true
    
    private var inset: CGFloat = 7
    private var bottomBorder: CALayer!
    private var computedPlaceholder: NSAttributedString {
        NSAttributedString(string: self.label.text!, attributes: [.foregroundColor: UIColor.appRed])
    }
    
    // MARK: - Overridden methods
    
    // placeholder position
    override func textRect(forBounds: CGRect) -> CGRect {
        return forBounds.insetBy(dx: inset, dy: inset)
    }
    // text position
    override func editingRect(forBounds: CGRect) -> CGRect {
        return forBounds.insetBy(dx: inset, dy: inset)
    }
    
    // placeholder animation when textField becomeFirstResponder
    override func becomeFirstResponder() -> Bool {
        addSubview(label)
        self.placeholder = nil
        adjustAppearance(isResignFirstResponder: false)
        UIView.animate(withDuration: 0.25, animations: {
            self.label.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.label.frame.origin = CGPoint(x: 0, y: -self.bounds.height / 2)
        })
        return super.becomeFirstResponder()
    }
    
    // placeholder animation when textField resignFirstResponder
    override func resignFirstResponder() -> Bool {
        if !self.hasText {
            adjustAppearance(isResignFirstResponder: true)
            UIView.animate(withDuration: 0.25, animations: {
                self.label.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.label.frame = self.textRect(forBounds: self.bounds)
            }, completion: { _ in
                self.label.removeFromSuperview()
                if self.isRequiredTextEntry {
                    self.attributedPlaceholder = self.computedPlaceholder
                }
            })
        }
        return super.resignFirstResponder()
    }
    
    // draw bottom border
    override func draw(_ rect: CGRect) {
        bottomBorder = addBorder(at: .bottom, color: .appBlack, width: 1.3)
    }
        
    private func adjustAppearance(isResignFirstResponder: Bool) {
        guard isRequiredTextEntry else { return }
        
        if isResignFirstResponder {
            self.label.textColor = .appRed
            self.bottomBorder.backgroundColor = UIColor.appRed.cgColor
        } else {
            self.label.textColor = .appBlack
            self.bottomBorder.backgroundColor = UIColor.appBlack.cgColor
        }
    }
}
