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
    
    func presentEditEmail(onSuccess: (() async -> Void)?) {
        let editEmailViewController = EditEmailViewController()
        let editEmailConfigurator = EditEmailConfiguratorImpl(successHandler: onSuccess)

        editEmailViewController.configurator = editEmailConfigurator
        editEmailViewController.modalTransitionStyle = .crossDissolve
        editEmailViewController.modalPresentationStyle = .overFullScreen
        
        viewController?.present(editEmailViewController, animated: true)
    }
    
    func presentEditPassword() {
        let editPasswordViewController = EditPasswordViewController()
        let editPasswordConfigurator = EditPasswordConfiguratorImpl()

        editPasswordViewController.configurator = editPasswordConfigurator
        editPasswordViewController.modalTransitionStyle = .crossDissolve
        editPasswordViewController.modalPresentationStyle = .overFullScreen
        
        viewController?.present(editPasswordViewController, animated: true)
    }
}
