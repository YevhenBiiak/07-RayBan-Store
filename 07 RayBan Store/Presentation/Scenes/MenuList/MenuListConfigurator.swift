//
//  MenuListConfigurator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 25.09.2022.
//

import UIKit

protocol MenuListConfigurator {
    func configure(menuListViewController: MenuListViewController)
}

class MenuListConfiguratorImpl: MenuListConfigurator {
    func configure(menuListViewController: MenuListViewController) {
        
        let router = MenuListRouterImpl(menuListViewController: menuListViewController)
        
        let remoteRepository = RemoteRepositoryImpl()
        let cartGateway = CartGatewayImpl(remoteRepository: remoteRepository)
        let isCartEmptyUseCase = IsCartEmptyUseCaseImpl(cartItemsGateway: cartGateway)
        
        let presenter = MenuListPresenterImpl(view: menuListViewController,
                                              router: router,
                                              isCartEmptyUseCase: isCartEmptyUseCase)
        
        menuListViewController.presenter = presenter
        menuListViewController.rootView = MenuListRootView()
    }
}
