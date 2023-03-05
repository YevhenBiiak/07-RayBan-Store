//
//  CartConfigurator.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 25.02.2023.
//

@MainActor
protocol CartConfigurator {
    func configure(cartViewController: CartViewController)
}

class CartConfiguratorImpl: CartConfigurator {
    
    func configure(cartViewController: CartViewController) {
        
        let productImagesApi = ProductImagesApiImpl()
        let remoteRepository = Session.shared.remoteRepositoryAPI
        
        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, imagesApi: productImagesApi)
        
        let cartGateway = CartGatewayImpl(cartAPI: remoteRepository, productGateway: productGateway)
        let cartUseCase = CartUseCaseImpl(cartGateway: cartGateway)
        
        let orderGateway = OrderGatewayImpl(orderApi: remoteRepository)
        let orderUseCase = OrderUseCaseImpl(orderGateway: orderGateway)
        
        let rootView = CartRootView()
        let router = CartRouterImpl(viewController: cartViewController)
        let presenter = CartPresenterImpl(view: cartViewController,
                                          router: router,
                                          cartUseCase: cartUseCase,
                                          orderUseCase: orderUseCase)
        
        cartViewController.presenter = presenter
        cartViewController.rootView = rootView
    }
}
