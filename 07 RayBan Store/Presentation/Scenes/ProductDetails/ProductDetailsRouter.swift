//
//  ProductDetailsRouter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 18.09.2022.
//

import UIKit

class ProductDetailsRouterImpl: Routable, ProductDetailsRouter {
    
    weak var viewController: ProductDetailsViewController!
    
    required init(viewController: ProductDetailsViewController) {
        self.viewController = viewController
    }
    
    func presentShoppingCart() {
        let cartViewController = CartViewController()
        let cartConfigurator = CartConfiguratorImpl()
        
        cartViewController.configurator = cartConfigurator
        navigationController?.pushViewController(cartViewController, animated: true)
    }
}
