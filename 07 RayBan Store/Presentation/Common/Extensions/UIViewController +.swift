//
//  UIViewController +.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 10.10.2022.
//

import UIKit

extension UIViewController {
    
    var topBarHeight: CGFloat? {
        (navigationController?.navigationBar.frame.height ?? 0) + (UIApplication.shared.statusBarHeight ?? 0)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - KeyboardNotificationObserver

extension UIViewController {
    // MARK: AssociatedKey
    
    private struct AssociatedKeys {
        static var defaultConstant = "defaultConstant"
        static var constraint = "constraint"
        static var defaultInset = "defaultInset"
        static var scrollView = "scrollView"
    }
    
    // MARK: Stored properties
    
    private weak var constraint: NSLayoutConstraint? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.constraint) as? NSLayoutConstraint
        } set {
            objc_setAssociatedObject(self, &AssociatedKeys.constraint, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var defaultConstant: CGFloat? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.defaultConstant) as? CGFloat
        } set {
            objc_setAssociatedObject(self, &AssociatedKeys.defaultConstant, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private weak var scrollView: UIScrollView? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.scrollView) as? UIScrollView
        } set {
            objc_setAssociatedObject(self, &AssociatedKeys.scrollView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var defaultInset: CGFloat? {
        get {
            objc_getAssociatedObject(self, &AssociatedKeys.defaultInset) as? CGFloat
        } set {
            objc_setAssociatedObject(self, &AssociatedKeys.defaultInset, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: Public method
    
    public func observeKeyboardNotification(for constraint: NSLayoutConstraint?, adjustOffsetFor scrollView: UIScrollView? = nil) {
        
        // remove observers of this object
        NotificationCenter.default.removeObserver(self)
        // add new observer
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideSelector), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowSelector), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        // save constraint and constant
        self.constraint = constraint
        self.defaultConstant = constraint?.constant
        
        // save scrollView and inset
        self.scrollView = scrollView
        self.defaultInset = scrollView?.contentInset.bottom
    }
    
    // MARK: Private notification selector
    
    @objc private func keyboardWillShowSelector(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let focusedField = UIResponder.firstResponder() as? UITextField,
              focusedField.isDescendant(of: view)
        else { return }
        
        var keyboardHeigh: CGFloat = 0
        
        // if view pinned to safeAreaLayoutGuide with positive constant value
        if constraint?.firstItem === view.safeAreaLayoutGuide {
            keyboardHeigh = keyboardFrame.height - view.safeAreaInsets.bottom
        }
        // if view pinned to safeAreaLayoutGuide with negative constant value
        if constraint?.secondItem === view.safeAreaLayoutGuide {
            keyboardHeigh = -(keyboardFrame.height - view.safeAreaInsets.bottom)
        }
        // if view pinned to its superview with positive constant value
        if constraint?.firstItem === view {
            keyboardHeigh = keyboardFrame.height
        }
        // if view pinned to its superview with negative constant value
        if constraint?.secondItem === view {
            keyboardHeigh = -keyboardFrame.height
        }
        
        let keyboardTop = view.convert(keyboardFrame, to: nil).minY
        let fieldBottom = focusedField.convert(focusedField.bounds, to: nil).maxY
        let offset = (scrollView?.contentOffset.y ?? 0) + max(0, fieldBottom - keyboardTop + 12)
        
        constraint?.constant = scrollView == nil ? max(0, fieldBottom - keyboardTop + 12) : keyboardHeigh
        
        scrollView?.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHideSelector(notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        else { return }
        
        constraint?.constant = defaultConstant ?? 0
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}

extension UIResponder {
    
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    /// Finds the current first responder
    /// - Returns: the current UIResponder if it exists
    static func firstResponder () -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc private func _trap() {
        Static.responder = self
    }
}
