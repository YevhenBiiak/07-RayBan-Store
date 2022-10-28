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
    func display(numberOfLoadingProducts: Int)
    func displayError(title: String, message: String?)
    func display(products: [ProductVM], totalNumberOfProducts: Int)
}

protocol ProductsPresenter {
    func viewDidLoad()
    func searchButtonTapped()
    func menuButtonTapped()
    func willDisplayItem(forIndex index: Int)
    func didSelectItem(atIndexPath indexPath: IndexPath)
}

class ProductsPresenterImpl: ProductsPresenter {
    
    private weak var view: ProductsView?
    private let router: ProductsRouter
    private let getProductsUseCase: GetProductsUseCase
    
    private var products: [ProductDTO] = []
    private var totalNumberOfProducts = 0
    private var isProductsLoadingNow = false
    
    private var currentType: ProductType = .sunglasses
    private var currentFamily: ProductFamily?
    private var currentCategory: ProductCategory?
    private let first = 6
    private var skip = 0
    
    init(view: ProductsView?, router: ProductsRouter, getProductsUseCase: GetProductsUseCase) {
        self.view = view
        self.router = router
        self.getProductsUseCase = getProductsUseCase
    }
    
    // MARK: - ProductsPresenter
    
    func viewDidLoad() {
        self.presentProducts(type: self.currentType)
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
    
    func willDisplayItem(forIndex index: Int) {
        guard index == products.count - 1, // 1 / 6
              isProductsLoadingNow == false,
              skip < totalNumberOfProducts
        else { return }
        print("load next part now")
        presentNextProducts()
    }
}

// MARK: - ProductsPresentationDelegate

extension ProductsPresenterImpl: ProductsPresentationDelegate {
    
    func presentProducts(type: ProductType) {
        resetState()
        view?.display(title: type.rawValue)
        presentProducts(type: type, category: nil, family: nil, first: first, skip: 0)
    }
    
    func presentProducts(type: ProductType, family: ProductFamily) {
        resetState()
        view?.display(title: type.rawValue + " " + family.rawValue)
        presentProducts(type: type, category: nil, family: family, first: first, skip: 0)
    }
    
    func presentProducts(type: ProductType, category: ProductCategory) {
        resetState()
        view?.display(title: type.rawValue + " " + category.rawValue)
        presentProducts(type: type, category: category, family: nil, first: first, skip: 0)
    }
}
    // MARK: - Private methods

extension ProductsPresenterImpl {
    
    private func resetState() {
        products = []
        totalNumberOfProducts = 0
        view?.display(products: [], totalNumberOfProducts: 0)
    }
    
    private func presentNextProducts() {
        presentProducts(
            type: currentType,
            category: currentCategory,
            family: currentFamily,
            first: first,
            skip: skip + first)
    }
    
    private func presentProducts(
        type: ProductType,
        category: ProductCategory?,
        family: ProductFamily?,
        first: Int, skip: Int
    ) {
        Task {
            // update state
            self.skip = skip
            currentType = type
            currentFamily = family
            currentCategory = category
            isProductsLoadingNow = true
            defer { isProductsLoadingNow = false }
            
            // display loading animation
            let left = self.totalNumberOfProducts - self.products.count // products left in DB
            let number = left > 0 && left < first ? left : first
            view?.display(numberOfLoadingProducts: number)
            
            // create request
            var request = GetProductsRequest(queries: .type(type), .limit(first: first, skip: skip))
            // add query if exist
            if let category { request.addQuery(query: .category(category)) }
            if let family { request.addQuery(query: .family(family)) }
            
            do {/* execute request */
                let response = try await getProductsUseCase.execute(request)
                // add products
                self.totalNumberOfProducts = response.totalNumberOfProducts
                self.products += response.products
                
                self.view?.display(products: self.products.asProductsVM,
                                   totalNumberOfProducts: response.totalNumberOfProducts)
            } catch {
                print(error)
                self.view?.displayError(title: error.localizedDescription, message: nil)
            }
        }
    }
}
