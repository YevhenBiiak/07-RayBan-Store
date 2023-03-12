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
        
        let productImagesApi = Session.shared.productImagesAPI
        let remoteRepository = Session.shared.remoteRepositoryAPI
        
        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, imagesApi: productImagesApi)
        let profileGateway = ProfileGatewayImpl(profilesAPI: remoteRepository)
        let orderGateway = OrderGatewayImpl(orderAPI: remoteRepository, productGateway: productGateway)
        
        let cartGateway = CartGatewayImpl(cartAPI: remoteRepository, productGateway: productGateway)
        let cartUseCase = CartUseCaseImpl(cartGateway: cartGateway, orderGateway: orderGateway)
        
        let router = AppMenuRouterImpl(appMenuViewController: listViewController,
                                       productsPresentationDelegate: productsPresentationDelegate)
        let presenter = AppMenuPresenterImpl(view: listViewController,
                                             router: router,
                                             cartUseCase: cartUseCase)
        
        listViewController.presenter = presenter
    }
}
