//
//  CartRouter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 25.02.2023.
//

class CartRouterImpl: Routable, CartRouter {
    
    weak var viewController: CartViewController!
    
    required init(viewController: CartViewController) {
        self.viewController = viewController
    }
    
    func presentProductDetails(product: Product) {
        let productDetailsViewController = ProductDetailsViewController()
        let productDetailsConfigurator = ProductDetailsConfiguratorImpl(product: product)

        productDetailsViewController.configurator = productDetailsConfigurator
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}
