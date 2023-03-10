//
//  FavoritesRouter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 01.03.2023.
//

import UIKit

class FavoritesRouterImpl: Routable, FavoritesRouter {
    
    weak var viewController: FavoritesViewController!
    
    required init(viewController: FavoritesViewController) {
        self.viewController = viewController
    }
    
    func presentProductDetails(product: Product) {
        let productDetailsViewController = ProductDetailsViewController()
        let productDetailsConfigurator = ProductDetailsConfiguratorImpl(product: product)

        productDetailsViewController.configurator = productDetailsConfigurator
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}
