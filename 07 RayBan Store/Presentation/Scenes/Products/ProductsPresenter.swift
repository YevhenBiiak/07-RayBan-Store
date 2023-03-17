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
    func hideMenuBadge()
    func displayMenuBadge()
    func display(productsSection: any Sectionable)
    func display(productItem: any Itemable, at index: Int)
    func displayError(title: String, message: String?)
}

protocol ProductsPresenter {
    func viewDidLoad() async
    func willAppearItems(at indices: [Int]) async
    func menuButtonTapped() async
    func willDisplayLastItem(at index: Int) async
    func didSelectItem(at index: Int) async
}

class ProductsPresenterImpl {
    
    private weak var view: ProductsView?
    private let router: ProductsRouter
    private let cartUseCase: CartUseCase
    private let getProductsUseCase: GetProductsUseCase
    
    private var currentCategory: Product.Category = .sunglasses
    private var currentGender: Product.Gender?
    private var currentStyle: Product.Style?
    
    private var isLoading: Bool = false
    private let batchSize: Int = 6
    private var productsCount: Int = 0
    
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
    
    func willDisplayLastItem(at index: Int) async {
        let (category, gender, style) = (currentCategory, currentGender, currentStyle)
        guard !isLoading, index + 1 < productsCount else { return }
        
        isLoading = true; defer { isLoading = false }
        let nextIndex = index + 1
        let range = nextIndex..<min(nextIndex + batchSize, productsCount)
        
        await with(errorHandler) {
            await range.asyncForEach { index in
                await view?.display(productItem: ProductItem(), at: index)
            }
            
            let request = ProductsRequest(
                category: category, gender: gender, style: style, range: range)
            let items = try await getProductsUseCase.execute(request)
                .concurrentMap(createViewModel)
                .map(ProductItem.init)
            
            // if it's still available request -> display it
            guard (currentCategory, currentGender, currentStyle) == (category, gender, style) else { return }
            await zip(items, range).asyncForEach { item in
                await view?.display(productItem: item.0, at: item.1)
            }
        }
    }
    
    func willAppearItems(at indices: [Int]) async {
        await with(errorHandler) {
            let (category, gender, style) = (currentCategory, currentGender, currentStyle)
            try await displayUpdatedMenuBadge()
            
            guard let first = indices.first, let last = indices.last else { return }
            let range = Range(first...last)
            
            let request = ProductsRequest(
                category: category, gender: gender, style: style, range: range)
            let items = try await getProductsUseCase.execute(request)
                .concurrentMap(createViewModel)
                .map(ProductItem.init)
            
            // if it's still available request -> display it
            guard (currentCategory, currentGender, currentStyle) == (category, gender, style) else { return }
            await zip(items, range).asyncForEach { item in
                await view?.display(productItem: item.0, at: item.1)
            }
        }
    }
    
    func menuButtonTapped() async {
        await router.presentAppMenu(productsPresentationDelegate: self)
    }
    
    func didSelectItem(at index: Int) async {
        await with(errorHandler) {
            let request = ProductRequest(category: currentCategory, gender: currentGender, style: currentStyle, index: index)
            let product = try await getProductsUseCase.execute(request)
            await router.presentProductDetails(product: product)
        }
    }
}

// MARK: - ProductsPresentationDelegate

extension ProductsPresenterImpl: ProductsPresentationDelegate {
    
    func presentProducts(category: Product.Category) async {
        await displayLoadingItems(andTitle: category.rawValue)
        await displayProducts(category: category, gender: nil, style: nil)
    }
    
    func presentProducts(category: Product.Category, style: Product.Style) async {
        await displayLoadingItems(andTitle: style.rawValue + " " + category.rawValue)
        await displayProducts(category: category, gender: nil, style: style)
    }
    
    func presentProducts(category: Product.Category, gender: Product.Gender) async {
        await displayLoadingItems(andTitle: gender.rawValue + " " + category.rawValue)
        await displayProducts(category: category, gender: gender, style: nil)
    }
}

// MARK: - Private extension

private extension ProductsPresenterImpl {
    
    func displayLoadingItems(andTitle title: String) async {
        // display products section with loading(empty) items
        let items = Array(repeating: ProductItem(), count: batchSize)
        let section = ProductsSection(header: "PRODUCTS", items: items)
        await view?.display(productsSection: section)
        await view?.display(title: title.uppercased())
    }
    
    func displayUpdatedMenuBadge() async throws {
        let isCartEmptyRequest = IsCartEmptyRequest(user: Session.shared.user)
        let isCartEmpty = try await cartUseCase.execute(isCartEmptyRequest)
        isCartEmpty ? await view?.hideMenuBadge() : await view?.displayMenuBadge()
    }
    
    func displayProducts(category: Product.Category, gender: Product.Gender?, style: Product.Style?) async {
        // update state with new presentation request
        (currentCategory, currentGender, currentStyle) = (category, gender, style)
        isLoading = true; defer { isLoading = false }
        
        await with(errorHandler) {
            try await displayUpdatedMenuBadge()
            
            // first phase (check that the products count is not equal to zero)
            let productsCountRequest = ProductsCountRequest(
                category: category, gender: gender, style: style)
            let productsCount = try await getProductsUseCase.execute(productsCountRequest)
            
            // if it's still available request -> update totalProductsCount value
            guard (currentCategory, currentGender, currentStyle) == (category, gender, style) else { return }
            self.productsCount = productsCount
            guard productsCount > 0 else {
                // update view with empty product section
                let section = ProductsSection(header: "", items: [])
                await view?.display(productsSection: section)
                return
            }
            
            // second phase (display range of product items)
            let range = 0..<min(batchSize, productsCount)
            let request = ProductsRequest(
                category: category, gender: gender, style: style, range: range)
            let items = try await getProductsUseCase.execute(request)
                .concurrentMap(createViewModel)
                .map(ProductItem.init)
            let header = "\(productsCount) PRODUCTS"
            let section = ProductsSection(header: header, items: items)
            
            // if it's still available request -> display it
            guard (currentCategory, currentGender, currentStyle) == (category, gender, style) else { return }
            await view?.display(productsSection: section)
        }
    }
    
    func addButtonTapped(productID: ProductID, at index: Int) async {
        await with(errorHandler) {
            let productRequest = ProductWithIDRequest(productID: productID)
            let product = try await getProductsUseCase.execute(productRequest)
            
            let addRequest = AddCartItemRequest(user: Session.shared.user, product: product, amount: 1)
            try await cartUseCase.execute(addRequest)
            
            // update view
            await view?.displayMenuBadge()
            let newViewModel = try await createViewModel(with: product)
            let productItem = ProductItem(viewModel: newViewModel)
            await view?.display(productItem: productItem, at: index)
        }
    }
    
    func createViewModel(with product: Product) async throws -> ProductCellViewModel? {
        guard let variation = product.variations.first else { return nil }
        
        let inCartRequest = IsProductInCartRequset(user: Session.shared.user, productID: variation.productID)
        let isInCart = try await cartUseCase.execute(inCartRequest)
        
        return ProductCellViewModel(
            productID: variation.productID,
            isNew: true, // :(
            isInCart: isInCart,
            name: product.name.uppercased(),
            price: "$ " + String(format: "%.2f", Double(variation.price) / 100.0),
            colors: "\(product.variations.count) COLORS",
            imageData: variation.imageData?.first ?? Data(),
            addButtonTapped: { [weak self] productID, index in
                await self?.addButtonTapped(productID: productID, at: index)
            },
            cartButtonTapped: { [weak self] in
                await self?.router.presentShoppingCart()
            }
        )
    }
    
    func errorHandler(_ error: Error) async {
        await view?.displayError(title: "Error", message: error.localizedDescription)
    }
}
