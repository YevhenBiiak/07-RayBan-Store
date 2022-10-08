//
//  ProductsPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import Foundation

protocol ProductsPresentationDelegate: AnyObject {
    func presentProducts(type: ProductType)
    func presentProducts(type: ProductType, family: ProductFamily)
    func presentProducts(type: ProductType, category: ProductCategory)
}

protocol ProductsRouter {
    func presentProductDetails(product: ProductDTO)
    func presentAppMenu(productsPresentationDelegate: ProductsPresentationDelegate?)
}

protocol ProductsView: AnyObject {
    func display(title: String)
    func displayError(title: String, message: String?)
    func display(viewModels: [ProductVM], totalNumberOfProducts: Int)
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
        presentProducts(type: .sunglasses)
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
    func presentProducts(type: ProductType) {
        switch type {
        case .sunglasses: handelSunglassesPresentation(category: nil, family: nil)
        case .eyeglasses: handelEyeglassesPresentation(category: nil, family: nil) }
    }
    
    func presentProducts(type: ProductType, family: ProductFamily) {
        switch type {
        case .sunglasses: handelSunglassesPresentation(category: nil, family: family)
        case .eyeglasses: handelEyeglassesPresentation(category: nil, family: family) }
    }
    
    func presentProducts(type: ProductType, category: ProductCategory) {
        switch type {
        case .sunglasses: handelSunglassesPresentation(category: category, family: nil)
        case .eyeglasses: handelEyeglassesPresentation(category: category, family: nil) }
    }
    
    // MARK: - Private methods
    
    private func handelSunglassesPresentation(category: ProductCategory?, family: ProductFamily?) {
        let title = ProductType.sunglasses.rawValue + " " + (category?.rawValue ?? family?.rawValue ?? "")
        
        view?.display(title: title)
        
        var request = GetProductsRequest(queries: .type(.sunglasses), .limit(first: 20, skip: 0))
        
        if let category { request.addQuery(query: .category(category)) }
        if let family { request.addQuery(query: .family(family)) }
        
        getProductsUseCase.execute(request, completionHandler: responseCompletionHandler)
    }
    
    private func handelEyeglassesPresentation(category: ProductCategory?, family: ProductFamily?) {
        let title = ProductType.eyeglasses.rawValue + " " + (category?.rawValue ?? family?.rawValue ?? "")
        
        view?.display(title: title)
        
        var request = GetProductsRequest(queries: .type(.eyeglasses), .limit(first: 20, skip: 0))
        
        if let category { request.addQuery(query: .category(category)) }
        if let family { request.addQuery(query: .family(family)) }
        
        getProductsUseCase.execute(request, completionHandler: responseCompletionHandler)
    }
    
    private func responseCompletionHandler(result: Result<GetProductsResponse>) {
        switch result {
        case .success(let response):
            products = response.products
            self.view?.display(viewModels: self.products.asProductsVM,
                               totalNumberOfProducts: response.totalNumberOfProducts)
        case .failure(let error):
            self.view?.displayError(title: error.localizedDescription, message: nil)
        }
    }
}
