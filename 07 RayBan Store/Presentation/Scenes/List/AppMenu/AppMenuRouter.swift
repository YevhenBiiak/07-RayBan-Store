//
//  AppMenuRouter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 25.09.2022.
//

import UIKit

class AppMenuRouterImpl: AppMenuRouter {
    private weak var appMenuViewController: ListViewController!
    
    init(appMenuViewController: ListViewController) {
        self.appMenuViewController = appMenuViewController
    }
    
    func presentAccountMenu() {
        let navigationController = appMenuViewController.navigationController
        let accountMenuViewController = ListViewController()
        let accountMenuConfigurator = AccountMenuConfiguratorImpl()
        
        accountMenuViewController.configurator = accountMenuConfigurator
        navigationController?.pushViewController(accountMenuViewController, animated: true)
    }
    
    func presentSunglassesCategories() {
        
    }
    
    func presentEyeglassesCategories() {
        
    }
    
    func presentShoppingCart() {
        
    }
}
