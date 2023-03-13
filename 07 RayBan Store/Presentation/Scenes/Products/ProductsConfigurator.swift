//
//  ProductsConfigurator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import Foundation

@MainActor
protocol ProductsConfigurator {
    func configure(productsViewController: ProductsViewController)
}

class ProductsConfiguratorImpl: ProductsConfigurator {
    
    func configure(productsViewController: ProductsViewController) {
        
        let productImagesApi = Session.shared.productImagesAPI
        let remoteRepository = Session.shared.remoteRepositoryAPI
        
        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, imagesApi: productImagesApi)
        let getProductsUseCase = GetProductsUseCaseImpl(productGateway: productGateway)
        
        let cartGateway = CartGatewayImpl(cartAPI: remoteRepository, productGateway: productGateway)
        let cartUseCase = CartUseCaseImpl(cartGateway: cartGateway)
        
        let rootView = ProductsRootView()
        let router = ProductsRouterImpl(viewController: productsViewController)
        let presenter = ProductsPresenterImpl(view: productsViewController,
                                              router: router,
                                              cartUseCase: cartUseCase,
                                              getProductsUseCase: getProductsUseCase)
        
        productsViewController.presenter = presenter
        productsViewController.rootView = rootView
    }
}
