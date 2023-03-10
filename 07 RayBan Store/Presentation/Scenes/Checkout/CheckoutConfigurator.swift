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
    
    let shippingMethod: ShippingMethod
    
    init(shippingMethod: ShippingMethod) {
        self.shippingMethod = shippingMethod
    }
    
    func configure(checkoutViewController: CheckoutViewController) {
        
        let productImagesApi = Session.shared.productImagesAPI
        let remoteRepository = Session.shared.remoteRepositoryAPI
        
        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, imagesApi: productImagesApi)
        
        let orderGateway = OrderGatewayImpl(orderApi: remoteRepository)
        
        let cartGateway = CartGatewayImpl(cartAPI: remoteRepository, productGateway: productGateway, orderGateway: orderGateway)
        let cartUseCase = CartUseCaseImpl(cartGateway: cartGateway)
        
        let profileGateway = ProfileGatewayImpl(profilesAPI: remoteRepository)
        let profileUseCase = ProfileUseCaseImpl(profileGateway: profileGateway)
        
        let rootView = CheckoutRootView()
        let router = CheckoutRouterImpl(viewController: checkoutViewController)
        let presenter = CheckoutPresenterImpl(shippingMethod: shippingMethod,
                                              view: checkoutViewController,
                                              router: router,
                                              cartUseCase: cartUseCase,
                                              profileUseCase: profileUseCase)
        
        checkoutViewController.presenter = presenter
        checkoutViewController.rootView = rootView
    }
}