//
//  RequiredTextField.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 01.02.2023.
//

import UIKit

class RequiredTextField: UITextField {
    
    var isRequiredTextEntry: Bool = true
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel(frame: textRect(forBounds: bounds))
        label.font = font
        return label
    }()
    
    private lazy var requirementsLabel: UILabel = {
        let label = UILabel(frame: textRect(forBounds: bounds))
        label.font = font
        return label
    }()
    
    private lazy var lastAttributedPlaceholder = attributedPlaceholder
    
    private var inset: CGFloat = 7
    private var bottomBorder: CALayer!
    private var observation: NSKeyValueObservation?
    
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
        showLabel(animated: true)
        return super.becomeFirstResponder()
    }
    
    // placeholder animation when textField resignFirstResponder
    override func resignFirstResponder() -> Bool {
        !hasText ? hideLabel(animated: true) : ()
        return super.resignFirstResponder()
    }
    
    // draw bottom border
    override func draw(_ rect: CGRect) {
        bottomBorder = addBorder(at: .bottom, color: .black, width: 1.3)
        observation = observe(\.text, options: .new) { [weak self] (_, change) in
            if change.newValue??.isEmpty == false {
                self?.showLabel(animated: false)
            }
        }
    }
    
    func triggerRequirements(with message: String) {
        requirementsLabel.text = message
        requirementsLabel.textColor = .red
        
        addSubview(requirementsLabel)
        placeholderLabel.removeFromSuperview()
        
        adjustAppearance(focused: false)
        UIView.performWithoutAnimation {
            requirementsLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            requirementsLabel.frame.origin = CGPoint(x: 0, y: -self.bounds.height / 2)
        }
    }
    
    // MARK: - Private methods
    
    private func showLabel(animated: Bool) {
        placeholderLabel.attributedText = lastAttributedPlaceholder
        self.attributedPlaceholder = nil
        
        requirementsLabel.removeFromSuperview()
        addSubview(placeholderLabel)
        
        adjustAppearance(focused: true)
        animated ? UIView.animate(withDuration: 0.25, animations: trasnform)
                 : UIView.performWithoutAnimation(trasnform)
        
        func trasnform() {
            self.placeholderLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.placeholderLabel.frame.origin = CGPoint(x: 0, y: -self.bounds.height / 2)
        }
    }
    
    private func hideLabel(animated: Bool) {
        adjustAppearance(focused: false)
        UIView.animate(withDuration: animated ? 0.25 : 0) {
            self.placeholderLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.placeholderLabel.frame = self.textRect(forBounds: self.bounds)
        } completion: { _ in
            self.placeholderLabel.removeFromSuperview()
            self.attributedPlaceholder = self.lastAttributedPlaceholder
        }
    }
    
    private func adjustAppearance(focused: Bool) {
        guard isRequiredTextEntry else { return }
        self.bottomBorder.backgroundColor = focused ? UIColor.black.cgColor
                                                    : UIColor.red.cgColor
    }
}
