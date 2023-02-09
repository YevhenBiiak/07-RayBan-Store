//
//  RegistrationRouter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.02.2023.
//

import UIKit

final class RegistrationRouterImpl: Routable, RegistrationRouter {
    
    weak var viewController: RegistrationViewController!
    
    required init(viewController: RegistrationViewController) {
        self.viewController = viewController
    }

    func presentProducts(user: User) {
        let productsViewController = ProductsViewController()
        let productsConfigurator = ProductsConfiguratorImpl(user: user)
        productsViewController.configurator = productsConfigurator
        
        navigationController?.setViewControllers([productsViewController], animated: true)
    }
}
