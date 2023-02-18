//
//  ProductDetailsPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 18.09.2022.
//

//import Foundation
//
//protocol ProductDetailsRouter {
//}
//
//protocol ProductDetailsView: AnyObject {
//    func display(product: ProductVM)
//    func displayError(title: String, message: String?)
//}
//
//protocol ProductDetailsPresenter {
//    func viewDidLoad()
//    func didSelectColor(_ color: String?)
//    func cartButtonTapped()
//}
//
//class ProductDetailsPresenterImpl: ProductDetailsPresenter {
//    
//    private weak var view: ProductDetailsView?
//    private let router: ProductDetailsRouter
//    private let getProductsUseCase: GetProductsUseCase
//    private let product: ProductDTO
//    
//    init(product: ProductDTO, view: ProductDetailsView?, router: ProductDetailsRouter, getProductsUseCase: GetProductsUseCase) {
//        self.product = product
//        self.view = view
//        self.router = router
//        self.getProductsUseCase = getProductsUseCase
//    }
//    
//    func viewDidLoad() {
//        view?.display(product: product.asProductVM)
//
//        let request = GetProductsRequest(queries: .id(product.id))
//
//        getProductsUseCase.execute(request) { [weak self] (result: Result<GetProductsResponse>) in
//            switch result {
//            case .success(let response):
//                if let product = response.products.first {
//                    self?.view?.display(product: product.asProductVM)
//                }
//            case .failure(let error):
//                self?.view?.displayError(title: error.localizedDescription, message: nil)
//            }
//        }
//    }
//    
//    func didSelectColor(_ color: String?) {
//        guard let color else { return }
//        let request = GetProductsRequest(queries: .id(product.id), .color(color))
//
//        getProductsUseCase.execute(request) { [weak self] (result: Result<GetProductsResponse>) in
//            switch result {
//            case .success(let response):
//                if let product = response.products.first {
//                    self?.view?.display(product: product.asProductVM)
//                }
//            case .failure(let error):
//                self?.view?.displayError(title: error.localizedDescription, message: nil)
//            }
//        }
//    }
//    
//    func cartButtonTapped() {
//        print("cartButtonTapped")
//    }
//}
