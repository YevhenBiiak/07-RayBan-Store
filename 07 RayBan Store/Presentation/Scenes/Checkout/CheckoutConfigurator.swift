//
//  CheckoutConfigurator.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.03.2023.
//

@MainActor
protocol CheckoutConfigurator {
    func configure(checkoutViewController: CheckoutViewController)
}

class CheckoutConfiguratorImpl: CheckoutConfigurator {
    
    private let cartItems: [CartItem]
    
    init(cartItems: [CartItem]) {
        self.cartItems = cartItems
    }
    
    func configure(checkoutViewController: CheckoutViewController) {
        
        let productImagesApi = Session.shared.productImagesAPI
        let remoteRepository = Session.shared.remoteRepositoryAPI
        
        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, imagesApi: productImagesApi)
        let cartGateway = CartGatewayImpl(cartAPI: remoteRepository, productGateway: productGateway)
        
        let profileGateway = ProfileGatewayImpl(profilesAPI: remoteRepository)
        let profileUseCase = ProfileUseCaseImpl(profileGateway: profileGateway)
        
        let orderGateway = OrderGatewayImpl(orderAPI: remoteRepository, cartGateway: cartGateway, productGateway: productGateway)
        let orderUseCase = OrderUseCaseImpl(orderGateway: orderGateway)
                
        let rootView = CheckoutRootView()
        let router = CheckoutRouterImpl(viewController: checkoutViewController)
        let presenter = CheckoutPresenterImpl(view: checkoutViewController,
                                              router: router,
                                              orderUseCase: orderUseCase,
                                              profileUseCase: profileUseCase,
                                              cartItems: cartItems)
        
        checkoutViewController.presenter = presenter
        checkoutViewController.rootView = rootView
    }
}
