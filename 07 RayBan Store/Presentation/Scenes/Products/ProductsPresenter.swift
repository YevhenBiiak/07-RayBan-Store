//
//  ProductsPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import Foundation

protocol ProductsPresentationDelegate: AnyObject {
    func presentProducts(type: ProductType, category: ProductCategory, family: ProductFamily)
}

protocol ProductsRouter {
    func presentProductDetails(product: ProductDTO)
    func presentAppMenu(productsPresentationDelegate: ProductsPresentationDelegate?)
}

protocol ProductsView: AnyObject {
    func display(title: String)
    func displayError(title: String, message: String?)
    func display(viewModels: [ProductViewModel], totalNumberOfProducts: Int)
}

protocol ProductsPresenter {
    func viewDidLoad()
    func searchButtonTapped()
    func menuButtonTapped()
    func didSelectItem(atIndexPath indexPath: IndexPath)
}

class ProductsPresenterImpl: ProductsPresenter {
    
    private weak var view: ProductsView?
    private let router: ProductsRouter
    private let getProductsUseCase: GetProductsUseCase
    
    private var products: [ProductDTO] = []
        
    init(view: ProductsView?, router: ProductsRouter, getProductsUseCase: GetProductsUseCase) {
        self.view = view
        self.router = router
        self.getProductsUseCase = getProductsUseCase
    }
    
    func viewDidLoad() {
        presentProducts(type: .sunglasses, category: .all, family: .all)
    }
    
    func searchButtonTapped() {
        print("searchButtonTapped")
    }
    func menuButtonTapped() {
        router.presentAppMenu(productsPresentationDelegate: self)
    }
    
    func didSelectItem(atIndexPath indexPath: IndexPath) {
        let product = products[indexPath.item]
        router.presentProductDetails(product: product)
    }
}

// MARK: - ProductsPresentationDelegate

extension ProductsPresenterImpl: ProductsPresentationDelegate {
    func presentProducts(type: ProductType, category: ProductCategory, family: ProductFamily) {
        switch type {
        case .sunglasses: handelSunglassesTypePresentation(category: category, family: family)
        case .eyeglasses: handelEyeglassesTypePresentation(category: category, family: family)
        }
    }
    
    // MARK: - Private methods
    
    private func handelSunglassesTypePresentation(category: ProductCategory, family: ProductFamily) {
        view?.display(title: "\(ProductType.sunglasses.rawValue) - \(family.rawValue) - \(category.rawValue)")
        
        let request = GetProductsRequest(query: .products(withType: .sunglasses, category: category, family: family, first: 20, skip: 0))
        getProductsUseCase.execute(request, completionHandler: responseCompletionHandler)
    }
    
    private func handelEyeglassesTypePresentation(category: ProductCategory, family: ProductFamily) {
        view?.display(title: "\(ProductType.eyeglasses.rawValue) - \(family.rawValue) - \(category.rawValue)")
        
        let request = GetProductsRequest(query: .products(withType: .eyeglasses, category: category, family: family, first: 20, skip: 0))
        getProductsUseCase.execute(request, completionHandler: responseCompletionHandler)
    }
    
    private func responseCompletionHandler(result: Result<GetProductsResponse>) {
        switch result {
        case .success(let response):
            products = response.products
            self.view?.display(viewModels: self.products.asProductsViewModel,
                               totalNumberOfProducts: response.totalNumberOfProducts)
        case .failure(let error):
            self.view?.displayError(title: error.localizedDescription, message: nil)
        }
    }
}
