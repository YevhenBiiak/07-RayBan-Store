//
//  EyeglassesCategoriesConfigurator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.10.2022.
//

import Foundation

class EyeglassesCategoriesConfiguratorImpl: CategoriesConfigurator {
    
    private weak var productsPresentationDelegate: ProductsPresentationDelegate?
    
    init(productsPresentationDelegate: ProductsPresentationDelegate?) {
        self.productsPresentationDelegate = productsPresentationDelegate
    }
    
    func configure(categoriesViewController: CategoriesViewController) {
        
        let router = EyeglassesCategoriesRouterImpl(eyeglassesCategoriesViewController: categoriesViewController,
                                                    productsPresentationDelegate: productsPresentationDelegate)
        
        let productImagesApi = ProductImagesApiImpl()
        let remoteRepository = RemoteRepositoryImpl()
        
        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, imagesApi: productImagesApi)
        let getProductsUseCase = GetProductsUseCaseImpl(productGateway: productGateway)
        
        let presenter = EyeglassesCategoriesPresenterImpl(view: categoriesViewController,
                                                          router: router,
                                                          getProductsUseCase: getProductsUseCase)
        
        categoriesViewController.presenter = presenter
        categoriesViewController.rootView = CategoriesRootView()
    }
}
