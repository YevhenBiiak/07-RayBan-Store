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
    func display(products: [ProductVM], totalNumberOfProducts: Int)
}

protocol ProductsPresenter {
    func viewDidLoad()
    func searchButtonTapped()
    func menuButtonTapped()
    func willDisplayedLastItem()
    func didSelectItem(atIndexPath indexPath: IndexPath)
}

class ProductsPresenterImpl: ProductsPresenter {
    
    private weak var view: ProductsView?
    private let router: ProductsRouter
    private let getProductsUseCase: GetProductsUseCase
    
    private var products: [ProductDTO] = []
    private var totalNumberOfProducts = 0
    
    private var currentType: ProductType = .sunglasses
    private var currentFamily: ProductFamily?
    private var currentCategory: ProductCategory?
    
    private let first = 10
    private var skip = 0
        
    init(view: ProductsView?, router: ProductsRouter, getProductsUseCase: GetProductsUseCase) {
        self.view = view
        self.router = router
        self.getProductsUseCase = getProductsUseCase
    }
    
    func viewDidLoad() {
        presentProducts(type: currentType)
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
    
    func willDisplayedLastItem() {
        presentNextPartOfProducts()
    }
}

// MARK: - ProductsPresentationDelegate

extension ProductsPresenterImpl: ProductsPresentationDelegate {
    func presentProducts(type: ProductType) {
        products = []
        view?.display(title: type.rawValue)
        handleProductPresentation(type: type, category: nil, family: nil, first: first, skip: 0)
    }
    
    func presentProducts(type: ProductType, family: ProductFamily) {
        products = []
        view?.display(title: type.rawValue + " " + family.rawValue)
        handleProductPresentation(type: type, category: nil, family: family, first: first, skip: 0)
    }
    
    func presentProducts(type: ProductType, category: ProductCategory) {
        products = []
        view?.display(title: type.rawValue + " " + category.rawValue)
        handleProductPresentation(type: type, category: category, family: nil, first: first, skip: 0)
    }
    
    // MARK: - Private methods
    
    private func presentNextPartOfProducts() {
        guard skip < totalNumberOfProducts else { return }
        handleProductPresentation(type: currentType, category: currentCategory, family: currentFamily, first: first, skip: skip + first)
    }
    
    private func handleProductPresentation(
        type: ProductType,
        category: ProductCategory?,
        family: ProductFamily?,
        first: Int, skip: Int
    ) {
        self.skip = skip
        currentType = type
        currentFamily = family
        currentCategory = category
        
        var request = GetProductsRequest(queries: .type(type), .limit(first: first, skip: skip))

        if let category { request.addQuery(query: .category(category)) }
        if let family { request.addQuery(query: .family(family)) }

        getProductsUseCase.execute(request, completionHandler: responseCompletionHandler)
    }
    
    private func responseCompletionHandler(result: Result<GetProductsResponse>) {
        switch result {
        case .success(let response):
            totalNumberOfProducts = response.totalNumberOfProducts
            
            for newProduct in response.products {
                if let index = products.firstIndex(where: { $0.id == newProduct.id }) {
                    products[index] = newProduct
                } else {
                    products.append(newProduct)
                }
            }
            
            self.view?.display(products: self.products.asProductsVM,
                               totalNumberOfProducts: response.totalNumberOfProducts)
        case .failure(let error):
            self.view?.displayError(title: error.localizedDescription, message: nil)
        }
    }
}
