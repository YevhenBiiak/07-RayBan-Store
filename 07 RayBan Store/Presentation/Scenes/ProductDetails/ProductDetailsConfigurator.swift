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

        let productImagesApi = Session.shared.productImagesAPI
        let remoteRepository = Session.shared.remoteRepositoryAPI
        
        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, imagesApi: productImagesApi)
        let getProductsUseCase = GetProductsUseCaseImpl(productGateway: productGateway)
        
        let profileGateway = ProfileGatewayImpl(profilesAPI: remoteRepository)
        let orderGateway = OrderGatewayImpl(orderAPI: remoteRepository, profileGateway: profileGateway)
        
        let cartGateway = CartGatewayImpl(cartAPI: remoteRepository, productGateway: productGateway, orderGateway: orderGateway)
        let cartUseCase = CartUseCaseImpl(cartGateway: cartGateway)
        
        let favoriteGateway = FavoriteGatewayImpl(favoriteAPI: remoteRepository, productGateway: productGateway)
        let favoriteUseCase = FavoriteUseCaseImpl(favoriteGateway: favoriteGateway)
        
        let router = ProductDetailsRouterImpl(viewController: productDetailsViewController)
        let presenter = ProductDetailsPresenterImpl(product: product,
                                                    view: productDetailsViewController,
                                                    router: router,
                                                    cartUseCase: cartUseCase,
                                                    favoriteUseCase: favoriteUseCase,
                                                    getProductsUseCase: getProductsUseCase)

        productDetailsViewController.presenter = presenter
        productDetailsViewController.rootView = ProductDetailsRootView()
    }
}
