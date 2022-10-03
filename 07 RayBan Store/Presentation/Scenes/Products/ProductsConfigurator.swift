//
//  ProductsConfigurator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import Foundation

protocol ProductsConfigurator {
    func configure(productsViewController: ProductsViewController)
}

class ProductsConfiguratorImpl: ProductsConfigurator {
    
    func configure(productsViewController: ProductsViewController) {
        
        let router = ProductsRouterImpl(productsViewController: productsViewController)
        
        let productImagesApi = ProductImagesApiImpl()
        let remoteRepository = RemoteRepositoryImpl()
        
        let productGateway = ProductGatewayImpl(productImagesApi: productImagesApi, remoteRepository: remoteRepository)
        let getProductsUseCase = GetProductsUseCaseImpl(productGateway: productGateway)
        
        let presenter = ProductsPresenterImpl(view: productsViewController,
                                              router: router,
                                              getProductsUseCase: getProductsUseCase)
        
        productsViewController.presenter = presenter
        productsViewController.rootView = ProductsRootView()
    }
}
