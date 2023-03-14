//
//  OrdersConfigurator.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 11.03.2023.
//

@MainActor
protocol OrdersConfigurator {
    func configure(ordersViewController: OrdersViewController)
}

class OrdersConfiguratorImpl: OrdersConfigurator {
    
    func configure(ordersViewController: OrdersViewController) {
        
        let productImagesApi = Session.shared.productImagesAPI
        let remoteRepository = Session.shared.remoteRepositoryAPI
        
        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, imagesApi: productImagesApi)
        
        let cartGateway = CartGatewayImpl(cartAPI: remoteRepository, productGateway: productGateway)
        let cartUseCase = CartUseCaseImpl(cartGateway: cartGateway)
        
        let orderGateway = OrderGatewayImpl(orderAPI: remoteRepository, cartGateway: cartGateway, productGateway: productGateway)
        let orderUseCase = OrderUseCaseImpl(orderGateway: orderGateway)
        
        let rootView = OrdersRootView()
        let router = OrdersRouterImpl(viewController: ordersViewController)
        let presenter = OrdersPresenterImpl(view: ordersViewController,
                                            router: router,
                                            cartUseCase: cartUseCase,
                                            orderUseCase: orderUseCase)
        
        ordersViewController.presenter = presenter
        ordersViewController.rootView = rootView
    }
}
