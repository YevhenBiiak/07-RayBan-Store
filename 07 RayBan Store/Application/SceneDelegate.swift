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
    
    private var networkMonitor: NetworkMonitor!
        
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let splashViewController = SplashViewController()
        let navigationController = UINavigationController(rootViewController: splashViewController)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        if let user = AuthProvider.currentUser {
            Session.shared.user = user
            // show main screen
            let productsViewController = ProductsViewController()
            productsViewController.configurator = ProductsConfiguratorImpl()
            navigationController.setViewControllers([productsViewController], animated: true)
        } else {
            // show login screen
            let loginViewController = LoginViewController()
            loginViewController.configurator = LoginConfiguratorImpl()
            navigationController.setViewControllers([loginViewController], animated: true)
        }
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurredView = UIVisualEffectView(effect: blurEffect)
        blurredView.frame = window?.frame ?? .zero
        
        networkMonitor = NetworkMonitor()
        networkMonitor.updateHandler = { [weak self] network in
            DispatchQueue.main.async {
                network.isConnected
                    ? self?.window?.rootViewController?.dismiss(animated: true)
                    : self?.window?.rootViewController?.showBlockingAlert(title: "Error", message: "Check your connection")
                self?.window?.isUserInteractionEnabled = network.isConnected
            }
        }
        networkMonitor.startMonitoring()
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
