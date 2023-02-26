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
        
        let rootView = CartRootView()
        let router = CartRouterImpl(viewController: cartViewController)
        let presenter = CartPresenterImpl(view: cartViewController,
                                            router: router)
        
        cartViewController.presenter = presenter
        cartViewController.rootView = rootView
    }
}
