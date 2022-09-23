//
//  ProductsPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import Foundation

protocol ProductsRouter {
    func presentProductDetailsScene(product: ProductDTO)
}

protocol ProductsView: AnyObject {
    func display(title: String)
    func displayError(title: String, message: String?)
    func display(viewModels: [ProductViewModel])
}

protocol ProductsPresenter {
    func viewDidLoad()
    func searchButtonTapped()
    func cartButtonTapped()
    func menuButtonTapped()
    func didSelectItems(atIndexPath indexPath: IndexPath)
}

class ProductsPresenterImpl: ProductsPresenter {
    
    private weak var view: ProductsView?
    private let router: ProductsRouter
    private let getProductsUseCase: GetProductsUseCase
    
    private var products: [ProductDTO] = []
        
    init(view: ProductsView, router: ProductsRouter, getProductsUseCase: GetProductsUseCase) {
        self.view = view
        self.router = router
        self.getProductsUseCase = getProductsUseCase
    }
    
    func viewDidLoad() {
        let request = GetProductsRequest(query: .all(first: 20, skip: 1))
        getProductsUseCase.execute(request) { [weak self] result in
            switch result {
            case .success(let response):
                self?.products = response.products
                DispatchQueue.main.async {
                    self?.view?.display(title: "PRODUCTS")
                    self?.view?.display(viewModels: self?.products.asProductsViewModel ?? [])
                }
            case .failure(let error):
                self?.view?.displayError(title: error.localizedDescription, message: nil)
            }
        }
    }
    
    func numberOfProducts() -> Int {
        products.count
    }
    
    func searchButtonTapped() {
        print("searchButtonTapped")
    }
    func cartButtonTapped() {
        print("cartButtonTapped")
    }
    func menuButtonTapped() {
        print("menuButtonTapped")
    }
    
    func didSelectItems(atIndexPath indexPath: IndexPath) {
        let product = products[indexPath.item]
        router.presentProductDetailsScene(product: product)
    }
}
