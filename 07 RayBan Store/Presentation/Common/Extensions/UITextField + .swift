//
//  UITextField + .swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 15.03.2023.
//

import UIKit

extension UITextField {
    
    /// Adds the UIAction to a given event.
    /// - by default controlEvents = .editingChanged
    func addAction(for controlEvents: UIControl.Event = .editingChanged, _ closure: @escaping (UITextField) -> Void) {
        let action = UIAction { _ in
            closure(self)
        }
        addAction(action, for: controlEvents)
    }
    
    func setAttributedPlaceholder(text: String) {
        if let currentAttributedPlaceholder = attributedPlaceholder {
            let newAttributedPlaceholder = NSAttributedString(string: text, attributes: currentAttributedPlaceholder.attributes(at: 0, effectiveRange: nil))
            attributedPlaceholder = newAttributedPlaceholder
        }
    }
}
