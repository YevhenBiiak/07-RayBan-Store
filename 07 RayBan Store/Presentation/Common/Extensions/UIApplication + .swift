//
//  UIApplication + .swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 05.02.2023.
//

import UIKit

extension UIApplication {
    
    var statusBarHeight: CGFloat? {
        return scene?.statusBarManager?.statusBarFrame.height
    }
    
    /// The first connected scene
    var scene: UIWindowScene? {
        UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
    
    /// The screen in first connected scene
    var screen: UIScreen? {
        scene?.screen
    }
    
    /// The first key window in connected scene
    var window: UIWindow? {
        scene?.windows.filter { $0.isKeyWindow }.first
    }
}
