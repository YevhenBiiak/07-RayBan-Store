//
//  ProductDetailsConfigurator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 18.09.2022.
//

import Foundation

@MainActor
protocol ProductDetailsConfigurator {
    func configure(productDetailsViewController: ProductDetailsViewController)
}

class ProductDetailsConfiguratorImpl: ProductDetailsConfigurator {
    
    private let product: Product

    init(product: Product) {
        self.product = product
    }

    func configure(productDetailsViewController: ProductDetailsViewController) {

        let productImagesApi = ProductImagesApiImpl()
        let remoteRepository = RemoteRepositoryImpl()

        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, imagesApi: productImagesApi)
        let getProductsUseCase = GetProductsUseCaseImpl(productGateway: productGateway)
        
        let router = ProductDetailsRouterImpl(viewController: productDetailsViewController)
        let presenter = ProductDetailsPresenterImpl(product: product,
                                                    view: productDetailsViewController,
                                                    router: router,
                                                    getProductsUseCase: getProductsUseCase)

        productDetailsViewController.presenter = presenter
        productDetailsViewController.rootView = ProductDetailsRootView()
    }
}
