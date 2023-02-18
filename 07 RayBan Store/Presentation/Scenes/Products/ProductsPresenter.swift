//
//  ProductsPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import Foundation

protocol ProductsPresentationDelegate: AnyObject {
    func presentProducts(category: Product.Category) async
    func presentProducts(category: Product.Category, style: Product.Style) async
    func presentProducts(category: Product.Category, gender: Product.Gender) async
}

@MainActor
protocol ProductsRouter {
    func presentProductDetails(product: Product)
    func presentAppMenu(productsPresentationDelegate: ProductsPresentationDelegate?)
}

@MainActor
protocol ProductsView: AnyObject {
    func display(title: String)
    func display(productsSection: any Sectionable)
    func display(productItem: any Itemable, at indexPath: IndexPath)
    func displayError(title: String, message: String?)
}

protocol ProductsPresenter {
    func viewDidLoad() async
    func menuButtonTapped() async
    func willDisplayLastItem(at indexPath: IndexPath) async
    func didSelectItem(at indexPath: IndexPath) async
}

class ProductsPresenterImpl {
    
    private weak var view: ProductsView?
    private let router: ProductsRouter
    private let getProductsUseCase: GetProductsUseCase
    
    private var currentCategory: Product.Category = .sunglasses
    private var currentGender: Product.Gender?
    private var currentStyle: Product.Style?
    
    private let requestStack = RequestStack(capacity: 6)
    private var totalProductsCount: Int = 0
    
    init(view: ProductsView?, router: ProductsRouter, getProductsUseCase: GetProductsUseCase) {
        self.view = view
        self.router = router
        self.getProductsUseCase = getProductsUseCase
    }
}

extension ProductsPresenterImpl: ProductsPresenter {
    
    func viewDidLoad() async {
        await presentProducts(category: currentCategory)
    }
    
    func menuButtonTapped() async {
        await router.presentAppMenu(productsPresentationDelegate: self)
    }
    
    func didSelectItem(at indexPath: IndexPath) async {
        await with(errorHandler) {
            let index = indexPath.item
            let request = ProductRequest(category: currentCategory, gender: currentGender, style: currentStyle, index: index)
            let product = try await getProductsUseCase.execute(request)
            await router.presentProductDetails(product: product)
        }
    }
    
    func willDisplayLastItem(at indexPath: IndexPath) async {
        let (category, gender, style) = (currentCategory, currentGender, currentStyle)
        let nextIndexPath = indexPath + 1
        guard nextIndexPath.item < totalProductsCount,
              requestStack.notContains(nextIndexPath) else { return }
        
        await requestStack.add(nextIndexPath)
        await displayLoadingItem(at: nextIndexPath)
        await with(errorHandler) {
            let request = ProductRequest(category: currentCategory, gender: currentGender, style: currentStyle, index: nextIndexPath.item)
            let product = try await getProductsUseCase.execute(request)
            
            // if it's still available request -> display it
            guard (currentCategory, currentGender, currentStyle) == (category, gender, style) else { return }
            
            let viewModel = productCellViewModel(with: product)
            let productItem = ProductItem(viewModel: viewModel)
            await view?.display(productItem: productItem, at: nextIndexPath)
        }
        
        requestStack.remove(nextIndexPath)
    }
}

// MARK: - ProductsPresentationDelegate

extension ProductsPresenterImpl: ProductsPresentationDelegate {
    
    func presentProducts(category: Product.Category) async {
        await displayEmptySection(andTitle: category.rawValue)
        await presentProducts(category: category, gender: nil, style: nil)
    }
    
    func presentProducts(category: Product.Category, style: Product.Style) async {
        await displayEmptySection(andTitle: category.rawValue + " " + style.rawValue)
        await presentProducts(category: category, gender: nil, style: style)
    }
    
    func presentProducts(category: Product.Category, gender: Product.Gender) async {
        await displayEmptySection(andTitle: category.rawValue + " " + gender.rawValue)
        await presentProducts(category: category, gender: gender, style: nil)
    }
}

// MARK: - Private methods

extension ProductsPresenterImpl {
    
    private func displayLoadingItem(at indexPath: IndexPath) async {
        await view?.display(productItem: ProductItem(), at: indexPath)
    }
    
    private func displayEmptySection(andTitle title: String) async {
        let section = ProductsSection(header: "0 PRODUCTS", items: [:])
        await view?.display(productsSection: section)
        await view?.display(title: title.uppercased())
    }
    
    private func presentProducts(category: Product.Category, gender: Product.Gender?, style: Product.Style?) async {
        // update state with new presentation request
        (currentCategory, currentGender, currentStyle) = (category, gender, style)
        
        await with(errorHandler) {
            // first phase
            let productsCountRequest = ProductsCountRequest(category: currentCategory, gender: currentGender, style: currentStyle)
            let productsCount = try await getProductsUseCase.execute(productsCountRequest)
            guard (currentCategory, currentGender, currentStyle) == (category, gender, style) else { return }
            
            totalProductsCount = productsCount
            if productsCount > 0 { await displayLoadingItem(at: IndexPath(item: 0, section: 0)) }
            
            // second phase
            let productRequest = ProductRequest(category: currentCategory, gender: currentGender, style: currentStyle, index: 0)
            let product = try await getProductsUseCase.execute(productRequest)
            guard (currentCategory, currentGender, currentStyle) == (category, gender, style) else { return }
            
            let header = "\(productsCount) PRODUCTS"
            let viewModel = productCellViewModel(with: product)
            let item = ProductItem(viewModel: viewModel)
            let section = ProductsSection(header: header, items: [IndexPath(item: 0, section: 0): item])
            await view?.display(productsSection: section)
        }
    }
    
    private func productCellViewModel(with product: Product) -> ProductCellViewModel? {
        guard let variation = product.variations.first else { return nil }
        return ProductCellViewModel(
            id: variation.productID,
            isNew: true, // hardcode :(
            name: product.name.uppercased(),
            price: "$ " + String(format: "%.2f", Double(variation.price) / 100.0),
            colors: "\(product.variations.count) COLORS",
            imgData: variation.imageData?.first ?? Data()
        )
    }
    
    private func errorHandler(_ error: Error) async {
        await view?.displayError(title: error.localizedDescription, message: nil)
    }
}
