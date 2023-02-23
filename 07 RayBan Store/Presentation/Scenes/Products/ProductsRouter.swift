//
//  ProductsRouter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import UIKit

class ProductsRouterImpl: Routable, ProductsRouter {
    
    weak var viewController: ProductsViewController!
    
    required init(viewController: ProductsViewController) {
        self.viewController = viewController
    }
    
    func presentProductDetails(product: Product) {
        let productDetailsViewController = ProductDetailsViewController()
        let productDetailsConfigurator = ProductDetailsConfiguratorImpl(product: product)

        productDetailsViewController.configurator = productDetailsConfigurator
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
    
    func presentAppMenu(productsPresentationDelegate: ProductsPresentationDelegate?) {
        let appMenuViewController = ListViewController()
        let appMenuConfigurator = AppMenuConfiguratorImpl(productsPresentationDelegate: productsPresentationDelegate)
        
        appMenuViewController.configurator = appMenuConfigurator
        navigationController?.pushViewController(appMenuViewController, animated: true)
    }
    
    func presentShoppingCart() {
        
    }
}
