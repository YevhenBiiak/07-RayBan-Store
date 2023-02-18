//
//  SunglassesCategoriesConfigurator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 01.10.2022.
//

//import Foundation
//
//class SunglassesCategoriesConfiguratorImpl: CategoriesConfigurator {
//    
//    private weak var productsPresentationDelegate: ProductsPresentationDelegate?
//    
//    init(productsPresentationDelegate: ProductsPresentationDelegate?) {
//        self.productsPresentationDelegate = productsPresentationDelegate
//    }
//    
//    func configure(categoriesViewController: CategoriesViewController) {
//        
//        let router = SunglassesCategoriesRouterImpl(sunglassesCategoriesViewController: categoriesViewController,
//                                                    productsPresentationDelegate: productsPresentationDelegate)
//        
//        let productImagesApi = ProductImagesApiImpl()
//        let remoteRepository = RemoteRepositoryImpl()
//        
//        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, productImagesApi: productImagesApi)
//        let getProductsUseCase = GetProductsUseCaseImpl(productGateway: productGateway)
//        
//        let presenter = SunglassesCategoriesPresenterImpl(view: categoriesViewController,
//                                                          router: router,
//                                                          getProductsUseCase: getProductsUseCase)
//        
//        categoriesViewController.presenter = presenter
//        categoriesViewController.rootView = CategoriesRootView()
//    }
//}
