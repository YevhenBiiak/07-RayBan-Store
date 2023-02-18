//
//  AccountMenuConfigurator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 29.09.2022.
//

class AccountMenuConfiguratorImpl: ListConfigurator {
    func configure(listViewController: ListViewController) {
        
        let router = AccountMenuRouterImpl(accountMenuViewController: listViewController)
        
        let remoteRepository = RemoteRepositoryImpl()
        let cartGateway = CartGatewayImpl(remoteRepository: remoteRepository)
        let cartUseCase = CartUseCaseImpl(cartGateway: cartGateway)
        
        let presenter = AccountMenuPresenterImpl(view: listViewController,
                                                 router: router,
                                                 cartUseCase: cartUseCase)
        
        listViewController.presenter = presenter
    }
}
