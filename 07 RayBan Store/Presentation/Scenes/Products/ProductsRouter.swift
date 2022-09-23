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
    
    func presentProductDetailsScene(product: ProductDTO) {
        let navigationController = productsViewController.navigationController
        let productDetailsViewController = ProductDetailsViewController()
        let productDetailsConfigurator = ProductDetailsConfiguratorImpl(product: product)
        
        productDetailsViewController.configurator = productDetailsConfigurator
        navigationController?.pushViewController(productDetailsViewController, animated: true)
    }
}
