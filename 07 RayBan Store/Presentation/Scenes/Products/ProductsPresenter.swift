//
//  ProductsPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import Foundation

protocol ProductsRouter {
    
}

protocol ProductsView: AnyObject {
    func displayTitle(_ title: String)
    func displayError(title: String, message: String?)
    func reloadView()
}

protocol ProductsPresenter {
    func viewDidLoad()
    func numberOfProducts() -> Int
    func configure(cell: ProductViewCell, forRowAt indexPath: IndexPath)
    func searchButtonTapped()
    func cartButtonTapped()
    func menuButtonTapped()
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
                    self?.view?.displayTitle("PRODUCTS")
                    self?.view?.reloadView()
                }
            case .failure(let error):
                self?.view?.displayError(title: error.localizedDescription, message: nil)
            }
        }
        
    }
    
    func numberOfProducts() -> Int {
        products.count
    }
    
    func configure(cell: ProductViewCell, forRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        
        cell.setIsNew(flag: true)
        cell.setTitle(product.title)
        
        cell.setImage(product.images?.main)
        cell.setPrice(product.price)
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
}
