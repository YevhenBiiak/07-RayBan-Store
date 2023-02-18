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
        
        let productImagesApi = ProductImagesApiImpl()
        let remoteRepository = RemoteRepositoryImpl()
        
        let cartGateway = CartGatewayImpl(remoteRepository: remoteRepository)
        let cartUseCase = CartUseCaseImpl(cartGateway: cartGateway)
        
        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, imagesApi: productImagesApi)
        let getProductsUseCase = GetProductsUseCaseImpl(productGateway: productGateway)
        
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
