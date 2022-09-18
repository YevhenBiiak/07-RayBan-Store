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
}
