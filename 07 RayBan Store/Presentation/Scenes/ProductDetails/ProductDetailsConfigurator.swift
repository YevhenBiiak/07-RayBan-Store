//
//  ProductDetailsConfigurator.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 18.09.2022.
//

//import Foundation
//
//protocol ProductDetailsConfigurator {
//    func configure(productDetailsViewController: ProductDetailsViewController)
//}
//
//class ProductDetailsConfiguratorImpl: ProductDetailsConfigurator {
//    private let product: ProductDTO
//
//    init(product: ProductDTO) {
//        self.product = product
//    }
//
//    func configure(productDetailsViewController: ProductDetailsViewController) {
//
//        let router = ProductDetailsRouterImpl(productDetailsViewController: productDetailsViewController)
//
//        let productImagesApi = ProductImagesApiImpl()
//        let remoteRepository = RemoteRepositoryImpl()
//
//        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, productImagesApi: productImagesApi)
//        let getProductsUseCase = GetProductsUseCaseImpl(productGateway: productGateway)
//        let presenter = ProductDetailsPresenterImpl(product: product,
//                                                    view: productDetailsViewController,
//                                                    router: router,
//                                                    getProductsUseCase: getProductsUseCase)
//
//        productDetailsViewController.presenter = presenter
//        productDetailsViewController.rootView = ProductDetailsRootView()
//    }
//}
