//
//  LoginRouter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 16.09.2022.
//

import UIKit

class LoginRouterImpl: Routable, LoginRouter {
    
    weak var viewController: LoginViewController!
    
    required init(viewController: LoginViewController) {
        self.viewController = viewController
    }
    
    func presentProducts(user: User) {
        let productsViewController = ProductsViewController()
        let productsConfigurator = ProductsConfiguratorImpl(user: user)
        productsViewController.configurator = productsConfigurator
        
        navigationController?.setViewControllers([productsViewController], animated: true)
    }
    
    func presentRegistrationScene() {
        let registrationViewController = RegistrationViewController()
        let registrationConfigurator = RegistrationConfiguratorImpl()
        
        registrationViewController.configurator = registrationConfigurator
        navigationController?.pushViewController(registrationViewController, animated: true)
    }
    
    func presentForgotPasswordScene() {
        let forgotPasswordViewController = ForgotPasswordViewController()
        let forgotPasswordConfigurator = ForgotPasswordConfiguratorImpl()
        
        forgotPasswordViewController.configurator = forgotPasswordConfigurator
        navigationController?.pushViewController(forgotPasswordViewController, animated: true)
    }
}
