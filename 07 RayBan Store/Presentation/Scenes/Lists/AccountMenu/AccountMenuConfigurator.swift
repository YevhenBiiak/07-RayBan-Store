//
//  AccountMenuConfigurator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 29.09.2022.
//

class AccountMenuConfiguratorImpl: ListConfigurator {
    
    func configure(listViewController: ListViewController) {
        
        let productImagesApi = Session.shared.productImagesAPI
        let remoteRepository = Session.shared.remoteRepositoryAPI
        
        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, imagesApi: productImagesApi)
        
        let orderGateway = OrderGatewayImpl(orderApi: remoteRepository)
        
        let cartGateway = CartGatewayImpl(cartAPI: remoteRepository, productGateway: productGateway, orderGateway: orderGateway)
        let cartUseCase = CartUseCaseImpl(cartGateway: cartGateway)
        
        let router = AccountMenuRouterImpl(viewController: listViewController)
        let presenter = AccountMenuPresenterImpl(view: listViewController,
                                                 router: router,
                                                 cartUseCase: cartUseCase)
        listViewController.presenter = presenter
    }
}
