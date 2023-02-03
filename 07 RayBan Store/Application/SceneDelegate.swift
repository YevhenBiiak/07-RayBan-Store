//
//  SceneDelegate.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 11.08.2022.
//

import UIKit
import FBSDKCoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
        
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let splashViewController = SplashViewController()
        let navigationController = UINavigationController(rootViewController: splashViewController)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
//        gG8RTBGOk2Qp6xGIVDjLuRIt9Ij1
        try? AuthProvider.logout()
        if let user = AuthProvider.currentUser {
            // show main screen
            let productsViewController = ProductsViewController()
            productsViewController.configurator = ProductsConfiguratorImpl(user: user)
            navigationController.setViewControllers([productsViewController], animated: true)
        } else {
            // show login screen
            let loginViewController = LoginViewController()
            loginViewController.configurator = LoginConfiguratorImpl()
            navigationController.setViewControllers([loginViewController], animated: true)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
}
