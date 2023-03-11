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
        
        let rootView = OrdersRootView()
        let router = OrdersRouterImpl(viewController: ordersViewController)
        let presenter = OrdersPresenterImpl(view: ordersViewController,
                                                router: router)
        
        ordersViewController.presenter = presenter
        ordersViewController.rootView = rootView
    }
}
