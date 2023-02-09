//
//  ForgotPasswordRouter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.02.2023.
//

import UIKit

class ForgotPasswordRouterImpl: Routable, ForgotPasswordRouter {
    
    weak var viewController: ForgotPasswordViewController!
    
    required init(viewController: ForgotPasswordViewController) {
        self.viewController = viewController
    }
    
    func presentRegistrationScene() {
        let registrationViewController = RegistrationViewController()
        let registrationConfigurator = RegistrationConfiguratorImpl()
        registrationViewController.configurator = registrationConfigurator
        
        var navigationStack = navigationController?.viewControllers
        navigationStack?.removeLast()
        navigationStack?.append(registrationViewController)
        
        navigationController?.setViewControllers(navigationStack!, animated: true)
    }
}
