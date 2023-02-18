//
//  AppMenuRouter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 25.09.2022.
//

import UIKit

class AppMenuRouterImpl: AppMenuRouter {
    
    private weak var appMenuViewController: ListViewController!
    private weak var productsPresentationDelegate: ProductsPresentationDelegate?
    
    private var navigationController: UINavigationController? {
        appMenuViewController.navigationController
    }
    
    init(appMenuViewController: ListViewController,
         productsPresentationDelegate: ProductsPresentationDelegate?) {
        
        self.appMenuViewController = appMenuViewController
        self.productsPresentationDelegate = productsPresentationDelegate
    }
    
    func presentAccountMenu() {
        let accountMenuViewController = ListViewController()
        let accountMenuConfigurator = AccountMenuConfiguratorImpl()
        
        accountMenuViewController.configurator = accountMenuConfigurator
        navigationController?.pushViewController(accountMenuViewController, animated: true)
    }
    
    func presentSunglassesCategories() {
//        let sunglassesCategoriesViewController = CategoriesViewController()
//        let sunglassesCategoriesConfigurator = SunglassesCategoriesConfiguratorImpl(
//            productsPresentationDelegate: productsPresentationDelegate)
//
//        sunglassesCategoriesViewController.configurator = sunglassesCategoriesConfigurator
//        navigationController?.pushViewController(sunglassesCategoriesViewController, animated: true)
    }
    
    func presentEyeglassesCategories() {
//        let eyeglassesCategoriesViewController = CategoriesViewController()
//        let eyeglassesCategoriesConfigurator = EyeglassesCategoriesConfiguratorImpl(
//            productsPresentationDelegate: productsPresentationDelegate)
//
//        eyeglassesCategoriesViewController.configurator = eyeglassesCategoriesConfigurator
//        navigationController?.pushViewController(eyeglassesCategoriesViewController, animated: true)
    }
    
    func presentShoppingCart() {
        
    }
}
