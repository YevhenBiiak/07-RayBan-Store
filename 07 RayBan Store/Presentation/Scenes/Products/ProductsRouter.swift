//
//  ProductsRouter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import UIKit

class ProductsRouterImpl: ProductsRouter {
    
    private weak var productsViewController: ProductsViewController!
    
    private var navigationController: UINavigationController? {
        productsViewController.navigationController
    }
    
    init(productsViewController: ProductsViewController) {
        self.productsViewController = productsViewController
    }
    
    func presentProductDetails(product: ProductDTO) {
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
}
