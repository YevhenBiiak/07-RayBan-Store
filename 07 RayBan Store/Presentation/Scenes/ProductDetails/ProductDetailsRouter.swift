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
        if let cartViewController = navigationController?.viewControllers.first(where: { $0 is CartViewController }) {
            navigationController?.popToViewController(cartViewController, animated: true)
        } else {
            let cartViewController = CartViewController()
            let cartConfigurator = CartConfiguratorImpl()
            
            cartViewController.configurator = cartConfigurator
            navigationController?.pushViewController(cartViewController, animated: true)
        }
    }
    
    func presentCheckout(cartItem: CartItem) {
        let checkoutViewController = CheckoutViewController()
        let checkoutConfigurator = CheckoutConfiguratorImpl(cartItems: [cartItem])

        checkoutViewController.configurator = checkoutConfigurator
        navigationController?.pushViewController(checkoutViewController, animated: true)
    }
}
