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
    func willDisplayItem(forIndex index: Int)
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
    private var skip = 0 {
        didSet {
            print("didSet skip: ", skip)
        }
    }
        
    init(view: ProductsView?, router: ProductsRouter, getProductsUseCase: GetProductsUseCase) {
        self.view = view
        self.router = router
        self.getProductsUseCase = getProductsUseCase
    }
    
    // MARK: - ProductsPresenter
    
    func viewDidLoad() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.presentProducts(type: self.currentType)
        }
    }
    
    func searchButtonTapped() {
        DispatchQueue.global().async {
            print("searchButtonTapped")
        }
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
              skip < totalNumberOfProducts,
              skip < products.count
        else { return }
        print("load next part now")
        presentNextProducts()
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
    
    private func presentNextProducts() {
        handleProductPresentation(
            type: currentType,
            category: currentCategory,
            family: currentFamily,
            first: first,
            skip: skip + first)
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

        getProductsUseCase.execute(request) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.totalNumberOfProducts = response.totalNumberOfProducts
                self.products += response.products
                
                self.view?.display(products: self.products.asProductsVM,
                                   totalNumberOfProducts: response.totalNumberOfProducts)
            case .failure(let error):
                self.view?.displayError(title: error.localizedDescription, message: nil)
            }
        }
    }
}
