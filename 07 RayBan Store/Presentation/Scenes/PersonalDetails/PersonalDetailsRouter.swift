//
//  PersonalDetailsRouter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 13.03.2023.
//

import UIKit

class PersonalDetailsRouterImpl: Routable, PersonalDetailsRouter {
    
    weak var viewController: PersonalDetailsViewController!
    
    required init(viewController: PersonalDetailsViewController) {
        self.viewController = viewController
    }
    
    func presentLoginScene() {
        let loginViewController = LoginViewController()
        let loginConfigurator = LoginConfiguratorImpl()
        
        loginViewController.configurator = loginConfigurator
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
}
