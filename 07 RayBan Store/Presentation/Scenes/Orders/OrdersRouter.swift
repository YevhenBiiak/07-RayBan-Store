//
//  OrdersRouter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 11.03.2023.
//

import UIKit

class OrdersRouterImpl: Routable, OrdersRouter {
    
    weak var viewController: OrdersViewController!
    
    required init(viewController: OrdersViewController) {
        self.viewController = viewController
    }
    
    func presentShoppingCart() {
        let cartViewController = CartViewController()
        let cartConfigurator = CartConfiguratorImpl()
        
        cartViewController.configurator = cartConfigurator
        navigationController?.pushViewController(cartViewController, animated: true)
    }
}
