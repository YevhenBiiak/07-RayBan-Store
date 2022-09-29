//
//  ProductsRouter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

class ProductsRouterImpl: ProductsRouter {
    private weak var productsViewController: ProductsViewController!
    
    init(productsViewController: ProductsViewController) {
        self.productsViewController = productsViewController
    }
    
    func presentProductDetails(product: ProductDTO) {
        let navigationController = productsViewController.navigationController
        let productDetailsViewController = ProductDetailsViewController()
        let productDetailsConfigurator = ProductDetailsConfiguratorImpl(product: product)
        
        productDetailsViewController.configurator = productDetailsConfigurator
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
    
    func presentAppMenu() {
        let navigationController = productsViewController.navigationController
        let appMenuViewController = ListViewController()
        let appMenuConfigurator = AppMenuConfiguratorImpl()
        
        appMenuViewController.configurator = appMenuConfigurator
        navigationController?.pushViewController(appMenuViewController, animated: true)
    }
}
