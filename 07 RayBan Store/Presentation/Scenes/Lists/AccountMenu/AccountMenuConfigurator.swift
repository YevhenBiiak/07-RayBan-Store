//
//  AccountMenuConfigurator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 29.09.2022.
//

class AccountMenuConfiguratorImpl: ListConfigurator {
    
    func configure(listViewController: ListViewController) {
        
        let remoteRepository = RemoteRepositoryImpl()
        let productImagesApi = ProductImagesApiImpl()
        
        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, imagesApi: productImagesApi)
        let cartGateway = CartGatewayImpl(cartAPI: remoteRepository, productGateway: productGateway)
        let cartUseCase = CartUseCaseImpl(cartGateway: cartGateway)
        
        let router = AccountMenuRouterImpl(accountMenuViewController: listViewController)
        let presenter = AccountMenuPresenterImpl(view: listViewController,
                                                 router: router,
                                                 cartUseCase: cartUseCase)
        listViewController.presenter = presenter
    }
}
