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
    
    private let user: User
    
    init(user: User) { self.user = user }
    
    func configure(productsViewController: ProductsViewController) {
        
        let productImagesApi = ProductImagesApiImpl()
        let remoteRepository = RemoteRepositoryImpl()
        
        let productGateway = ProductGatewayImpl(productImagesApi: productImagesApi, remoteRepository: remoteRepository)
        let getProductsUseCase = GetProductsUseCaseImpl(productGateway: productGateway)
        
        let rootView = ProductsRootView()
        let router = ProductsRouterImpl(productsViewController: productsViewController)
        let presenter = ProductsPresenterImpl(view: productsViewController,
                                              router: router,
                                              getProductsUseCase: getProductsUseCase)
        
        productsViewController.presenter = presenter
        productsViewController.rootView = rootView
    }
}
