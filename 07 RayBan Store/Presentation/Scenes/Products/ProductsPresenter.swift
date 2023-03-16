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
    
    func willDisplayLastItem(at index: Int) async {
        let (category, gender, style) = (currentCategory, currentGender, currentStyle)
        let nextIndex = index + 1
        guard nextIndex < totalProductsCount,
              requestStack.notContains(nextIndex) else { return }
        
        await requestStack.add(nextIndex)
        await with(errorHandler) {
            // if it's still available request -> display loading item
            guard (currentCategory, currentGender, currentStyle) == (category, gender, style) else { return }
            await view?.display(productItem: ProductItem(), at: nextIndex)
            
            let productRequest = ProductRequest(category: category, gender: gender, style: style, index: nextIndex)
            let product = try await getProductsUseCase.execute(productRequest)
            let viewModel = try await createViewModel(with: product)
            let productItem = ProductItem(viewModel: viewModel)
            
            // if it's still available request -> display it
            guard (currentCategory, currentGender, currentStyle) == (category, gender, style) else { return }
            await view?.display(productItem: productItem, at: nextIndex)
        }
        requestStack.remove(nextIndex)
    }
    
    func willAppearItems(at indices: [Int]) async {
        await with(errorHandler) {
            let (category, gender, style) = (currentCategory, currentGender, currentStyle)
            
            let isCartEmptyRequest = IsCartEmptyRequest(user: Session.shared.user)
            let isCartEmpty = try await cartUseCase.execute(isCartEmptyRequest)
            isCartEmpty ? await view?.hideMenuBadge() : await view?.displayMenuBadge()
            
            let productsRequest = ProductsRequest(category: category, gender: gender, style: style, indices: indices)
            let products = try await getProductsUseCase.execute(productsRequest)
            
            let viewModels = try await products.concurrentMap { [weak self] in
                try await self?.createViewModel(with: $0)
            }.compactMap{$0}
            
            // if it's still available request -> display it
            guard (currentCategory, currentGender, currentStyle) == (category, gender, style) else { return }
            let header = "\(totalProductsCount) PRODUCTS"
            let items = viewModels.map { ProductItem(viewModel: $0) }
            let section = ProductsSection(header: header, items: items)
            await view?.display(productsSection: section)
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
        await displayEmptySection(andTitle: category.rawValue)
        await presentProducts(category: category, gender: nil, style: nil)
    }
    
    func presentProducts(category: Product.Category, style: Product.Style) async {
        await displayEmptySection(andTitle: style.rawValue + " " + category.rawValue)
        await presentProducts(category: category, gender: nil, style: style)
    }
    
    func presentProducts(category: Product.Category, gender: Product.Gender) async {
        await displayEmptySection(andTitle: gender.rawValue + " " + category.rawValue)
        await presentProducts(category: category, gender: gender, style: nil)
    }
}

// MARK: - Private extension

private extension ProductsPresenterImpl {
    
    func displayEmptySection(andTitle title: String) async {
        let section = ProductsSection(header: "0 PRODUCTS", items: [])
        await view?.display(productsSection: section)
        await view?.display(title: title.uppercased())
    }
    
    func presentProducts(category: Product.Category, gender: Product.Gender?, style: Product.Style?) async {
        // update state with new presentation request
        (currentCategory, currentGender, currentStyle) = (category, gender, style)
        
        await with(errorHandler) {
            let isCartEmptyRequest = IsCartEmptyRequest(user: Session.shared.user)
            let isCartEmpty = try await cartUseCase.execute(isCartEmptyRequest)
            isCartEmpty ? await view?.hideMenuBadge() : await view?.displayMenuBadge()
            
            // first phase (display products count and loading item)
            let productsCountRequest = ProductsCountRequest(category: currentCategory, gender: currentGender, style: currentStyle)
            let productsCount = try await getProductsUseCase.execute(productsCountRequest)
            guard (currentCategory, currentGender, currentStyle) == (category, gender, style) else { return }
            
            totalProductsCount = productsCount
            guard productsCount > 0 else { return }
            
            let header = "\(productsCount) PRODUCTS"
            let section = ProductsSection(header: header, items: [ProductItem()])
            await view?.display(productsSection: section)
            
            // second phase (display first product item)
            let productRequest = ProductRequest(category: currentCategory, gender: currentGender, style: currentStyle, index: 0)
            let product = try await getProductsUseCase.execute(productRequest)
            let viewModel = try await createViewModel(with: product)
            
            // if it's still available request -> display it
            guard (currentCategory, currentGender, currentStyle) == (category, gender, style) else { return }
            let item = ProductItem(viewModel: viewModel)
            await view?.display(productItem: item, at: 0)
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
