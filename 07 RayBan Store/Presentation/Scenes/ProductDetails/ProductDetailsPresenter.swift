//
//  ProductDetailsPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 18.09.2022.
//

import Foundation

protocol ProductDetailsRouter {
}

protocol ProductDetailsView: AnyObject {
    func display(viewModel: ProductViewModel)
    func displayError(title: String, message: String?)
}

protocol ProductDetailsPresenter {
    func viewDidLoad()
}

class ProductDetailsPresenterImpl: ProductDetailsPresenter {
    
    private weak var view: ProductDetailsView?
    private let router: ProductDetailsRouter
    private let getProductsUseCase: GetProductsUseCase
    private let product: ProductDTO
    
    init(product: ProductDTO, view: ProductDetailsView?, router: ProductDetailsRouter, getProductsUseCase: GetProductsUseCase) {
        self.product = product
        self.view = view
        self.router = router
        self.getProductsUseCase = getProductsUseCase
    }
    
    func viewDidLoad() {
        view?.display(viewModel: product.asProductViewModel)
        /*
        let request = GetProductsRequest(query: .identifier(id: "\(product.id)"))
        getProductsUseCase.execute(request) { [weak self] (result: Result<GetProductsResponse>) in
            switch result {
            case .success(let response):
                if let product = response.products.first {
                    DispatchQueue.main.async {
                        self?.view?.display(viewModel: product.asProductViewModel)
                    }
                }
            case .failure(let error):
                self?.view?.displayError(title: error.localizedDescription, message: nil)
            }
        }
        */
    }
}
