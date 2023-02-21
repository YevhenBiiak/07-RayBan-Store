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
    func presentShoppingCart()
}

@MainActor
protocol ProductsView: AnyObject {
    func display(title: String)
    func display(productsSection: any Sectionable)
    func display(productItem: any Itemable, at index: Int)
    func displayError(title: String, message: String?)
}

protocol ProductsPresenter {
    func viewDidLoad() async
    func menuButtonTapped() async
    func willDisplayLastItem(at index: Int) async
    func didSelectItem(at indexPath: IndexPath) async
}

class ProductsPresenterImpl {
    
    private weak var view: ProductsView?
    private let router: ProductsRouter
    private let cartUseCase: CartUseCase
    private let getProductsUseCase: GetProductsUseCase
    
    private var currentCategory: Product.Category = .sunglasses
    private var currentGender: Product.Gender?
    private var currentStyle: Product.Style?
    
    private let requestStack = RequestStack(capacity: 6)
    private var totalProductsCount: Int = 0
    
    init(view: ProductsView?, router: ProductsRouter, cartUseCase: CartUseCase, getProductsUseCase: GetProductsUseCase) {
        self.view = view
        self.router = router
        self.cartUseCase = cartUseCase
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
    
    func willDisplayLastItem(at index: Int) async {
        let (category, gender, style) = (currentCategory, currentGender, currentStyle)
        let nextIndex = index + 1
        guard nextIndex < totalProductsCount,
              requestStack.notContains(nextIndex) else { return }
        
        await requestStack.add(nextIndex)
        await displayLoadingItem(at: nextIndex)
        await with(errorHandler) {
            let productRequest = ProductRequest(category: currentCategory, gender: currentGender, style: currentStyle, index: nextIndex)
            let product = try await getProductsUseCase.execute(productRequest)
            
            // if it's still available request -> display it
            guard (currentCategory, currentGender, currentStyle) == (category, gender, style) else { return }
            
            let viewModel = try await createViewModel(with: product, forIndex: nextIndex)
            let productItem = ProductItem(viewModel: viewModel)
            await view?.display(productItem: productItem, at: nextIndex)
        }
        
        requestStack.remove(nextIndex)
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
    
    private func displayLoadingItem(at index: Int) async {
        await view?.display(productItem: ProductItem(), at: index)
    }
    
    private func displayEmptySection(andTitle title: String) async {
        let section = ProductsSection(header: "0 PRODUCTS", items: [])
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
            if productsCount > 0 {
                let header = "\(productsCount) PRODUCTS"
                let section = ProductsSection(header: header, items: [ProductItem()])
                await view?.display(productsSection: section)
            }
            
            // second phase
            let productRequest = ProductRequest(category: currentCategory, gender: currentGender, style: currentStyle, index: 0)
            let product = try await getProductsUseCase.execute(productRequest)
            guard (currentCategory, currentGender, currentStyle) == (category, gender, style) else { return }
            
            let viewModel = try await createViewModel(with: product, forIndex: 0)
            let item = ProductItem(viewModel: viewModel)
            await view?.display(productItem: item, at: 0)
        }
    }
    
    private func addProductTapped(in viewModel: ProductCellViewModel) async {
        await with(errorHandler) {
            let productRequest = ProductWithIDRequest(productID: viewModel.productID)
            let product = try await getProductsUseCase.execute(productRequest)
            
            let addRequest = AddCartItemRequest(user: Session.shared.user, product: product, amount: 1)
            try await cartUseCase.execute(addRequest)
            // update cell
            let newViewModel = try await createViewModel(with: product, forIndex: viewModel.index)
            let productItem = ProductItem(viewModel: newViewModel)
            await view?.display(productItem: productItem, at: viewModel.index)
        }
    }
    
    private func createViewModel(with product: Product, forIndex index: Int) async throws -> ProductCellViewModel? {
        guard let variation = product.variations.first else { return nil }
        
        let inCartRequest = IsProductInCartRequset(user: Session.shared.user, product: product)
        let isInCart = try await cartUseCase.execute(inCartRequest)
        
        return ProductCellViewModel(
            productID: variation.productID,
            isNew: true, // hardcode :(
            isInCart: isInCart,
            name: product.name.uppercased(),
            price: "$ " + String(format: "%.2f", Double(variation.price) / 100.0),
            colors: "\(product.variations.count) COLORS",
            imageData: variation.imageData?.first ?? Data(),
            index: index,
            addButtonTapped: { [weak self] viewModel in
                await self?.addProductTapped(in: viewModel)
            },
            cartButtonTapped: { [weak self] in
                await self?.router.presentShoppingCart()
            }
        )
    }
    
    private func errorHandler(_ error: Error) async {
        await view?.displayError(title: error.localizedDescription, message: nil)
    }
}
