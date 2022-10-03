//
//  AppMenuConfigurator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 25.09.2022.
//

class AppMenuConfiguratorImpl: ListConfigurator {
    
    private weak var productsPresentationDelegate: ProductsPresentationDelegate?
    
    init(productsPresentationDelegate: ProductsPresentationDelegate?) {
        self.productsPresentationDelegate = productsPresentationDelegate
    }
    
    func configure(listViewController: ListViewController) {
        
        let router = AppMenuRouterImpl(appMenuViewController: listViewController,
                                       productsPresentationDelegate: productsPresentationDelegate)
        
        let remoteRepository = RemoteRepositoryImpl()
        let cartGateway = CartGatewayImpl(remoteRepository: remoteRepository)
        let isCartEmptyUseCase = IsCartEmptyUseCaseImpl(cartItemsGateway: cartGateway)
        
        let presenter = AppMenuPresenterImpl(view: listViewController,
                                              router: router,
                                              isCartEmptyUseCase: isCartEmptyUseCase)
        
        listViewController.presenter = presenter
        listViewController.rootView = ListRootView()
    }
}
