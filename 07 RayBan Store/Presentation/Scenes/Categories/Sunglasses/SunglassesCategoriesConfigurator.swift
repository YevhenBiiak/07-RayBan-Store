//
//  SunglassesCategoriesConfigurator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 01.10.2022.
//

import Foundation

class SunglassesCategoriesConfiguratorImpl: CategoriesConfigurator {
    
    private weak var productsPresentationDelegate: ProductsPresentationDelegate?
    
    init(productsPresentationDelegate: ProductsPresentationDelegate?) {
        self.productsPresentationDelegate = productsPresentationDelegate
    }
    
    func configure(categoriesViewController: CategoriesViewController) {
        
        let productImagesApi = Session.shared.productImagesAPI
        let remoteRepository = Session.shared.remoteRepositoryAPI
        
        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, imagesApi: productImagesApi)
        let getProductsUseCase = GetProductsUseCaseImpl(productGateway: productGateway)
        
        let router = SunglassesCategoriesRouterImpl(sunglassesCategoriesViewController: categoriesViewController,
                                                    productsPresentationDelegate: productsPresentationDelegate)
        let presenter = SunglassesCategoriesPresenterImpl(view: categoriesViewController,
                                                          router: router,
                                                          getProductsUseCase: getProductsUseCase)
        categoriesViewController.presenter = presenter
        categoriesViewController.rootView = CategoriesRootView()
    }
}
