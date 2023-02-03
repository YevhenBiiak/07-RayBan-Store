//
//  LoginRouter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 16.09.2022.
//

import UIKit

class LoginRouterImpl: LoginRouter {
    
    private weak var viewController: LoginViewController!
    
    private var navigationController: UINavigationController? {
        viewController.navigationController
    }
    
    init(viewController: LoginViewController) {
        self.viewController = viewController
    }
    
    func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        viewController?.dismiss(animated: flag, completion: completion)
    }

    func presentProducts(user: User) {
        // create Products viewcontroller
    }
    
    func presentRegistrationScene() {
        let registrationViewController = RegistrationViewController()
        let registrationConfigurator = RegistrationConfiguratorImpl()
        
        registrationViewController.configurator = registrationConfigurator
        navigationController?.pushViewController(registrationViewController, animated: true)
    }
}
