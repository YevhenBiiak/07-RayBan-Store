//
//  ProductDetailsPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 18.09.2022.
//

import Foundation

@MainActor
protocol ProductDetailsRouter {
    func presentShoppingCart()
    func presentCheckout(cartItem: CartItem)
}

@MainActor
protocol ProductDetailsView: AnyObject {
    func hideCartBadge()
    func displayCartBadge()
    func display(viewModel: ProductDetailsViewModel)
    func displayError(title: String, message: String?)
}

protocol ProductDetailsPresenter {
    func viewDidLoad() async
    func viewWillAppear() async
    func didSelectColorSegment(at index: Int) async
    func addToCartButtonTapped(productID: ProductID) async
    func favoriteButtonTapped(isFavorite: Bool) async
    func buyNowButtonTapped(productID: ProductID) async
    func showCartButtonTapped() async
}

class ProductDetailsPresenterImpl {
    
    private weak var view: ProductDetailsView?
    private let router: ProductDetailsRouter
    private let cartUseCase: CartUseCase
    private let favoriteUseCase: FavoriteUseCase
    private let getProductsUseCase: GetProductsUseCase
    
    private var product: Product
    private var currentVariationIndex = 0
    
    init(product: Product, view: ProductDetailsView?,
         router: ProductDetailsRouter,
         cartUseCase: CartUseCase,
         favoriteUseCase: FavoriteUseCase,
         getProductsUseCase: GetProductsUseCase
    ) {
        self.product = product
        self.view = view
        self.router = router
        self.cartUseCase = cartUseCase
        self.favoriteUseCase = favoriteUseCase
        self.getProductsUseCase = getProductsUseCase
    }
}

extension ProductDetailsPresenterImpl: ProductDetailsPresenter {
    
    func viewDidLoad() async {
        await with(errorHandler) {
            // display the product passed to the initializer 
            let viewModel = createProductViewModel(with: product, isInCart: false, isInFavorite: false)
            await view?.display(viewModel: viewModel)
            
            // display cart badge
            let isCartEmptyRequest = IsCartEmptyRequest(user: Session.shared.user)
            let isCartEmpty = try await cartUseCase.execute(isCartEmptyRequest)
            isCartEmpty ? await view?.hideCartBadge() : await view?.displayCartBadge()
            
            // load all images for variations and display selected
            let request = ProductWithModelIDRequest(modelID: product.modelID)
            product = try await getProductsUseCase.execute(request)
            try await displayUpdatedViewModel()
        }
    }
    
    func viewWillAppear() async {
        await with(errorHandler) {
            // display cart badge
            let isCartEmptyRequest = IsCartEmptyRequest(user: Session.shared.user)
            let isCartEmpty = try await cartUseCase.execute(isCartEmptyRequest)
            isCartEmpty ? await view?.hideCartBadge() : await view?.displayCartBadge()

            try await displayUpdatedViewModel()
        }
    }
    
    func didSelectColorSegment(at index: Int) async {
        await with(errorHandler) {
            currentVariationIndex = index
            try await displayUpdatedViewModel()
        }
    }
    
    func addToCartButtonTapped(productID: Int) async {
        await with(errorHandler) {
            let productRequest = ProductWithIDRequest(productID: productID, options: .noImages)
            let product = try await getProductsUseCase.execute(productRequest)
            
            let addRequest = AddCartItemRequest(user: Session.shared.user, product: product, amount: 1)
            try await cartUseCase.execute(addRequest)
            
            await view?.displayCartBadge()
            try await displayUpdatedViewModel()
        }
    }
    
    func favoriteButtonTapped(isFavorite: Bool) async {
        await with(errorHandler) {
            if isFavorite {
                let request = AddFavoriteItemRequest(user: Session.shared.user, product: product)
                try await favoriteUseCase.execute(request)
            } else {
                let request = DeleteFavoriteItemRequest(user: Session.shared.user, modelID: product.modelID, options: .noImages)
                try await favoriteUseCase.execute(request)
            }
        }
    }
    
    func buyNowButtonTapped(productID: ProductID) async {
        var product = self.product
        product.variations = [product.variations[currentVariationIndex]]
        await router.presentCheckout(cartItem: .init(product: product, amount: 1))
    }
    
    func showCartButtonTapped() async {
        await router.presentShoppingCart()
    }
}

// MARK: - Private methods

extension ProductDetailsPresenterImpl {
    
    private func displayUpdatedViewModel() async throws {
        let inCartRequest = IsProductInCartRequset(
            user: Session.shared.user,
            productID: product.variations[currentVariationIndex].productID
        )
        let isInCart = try await cartUseCase.execute(inCartRequest)
        
        let inFavoriteRequest = IsItemInFavoriteRequset(user: Session.shared.user, product: product)
        let isInFavorite = try await favoriteUseCase.execute(inFavoriteRequest)
        
        let viewModel = createProductViewModel(with: product, isInCart: isInCart, isInFavorite: isInFavorite)
        await view?.display(viewModel: viewModel)
    }
    
    private func createProductViewModel(with product: Product, isInCart: Bool, isInFavorite: Bool) -> ProductDetailsViewModel {
        let selectedVariation = product.variations[currentVariationIndex]
        return .init(
            modelID: product.modelID,
            productID: selectedVariation.productID,
            isInCart: isInCart,
            isInFavorite: isInFavorite,
            name: product.name.uppercased(),
            category: product.category.rawValue.uppercased(),
            gender: product.gender.rawValue.uppercased(),
            style: product.style.rawValue.uppercased(),
            size: product.size.uppercased(),
            geofit: product.geofit.uppercased(),
            colors: product.variations.map { "\($0.frameColor)/\($0.lenseColor)".uppercased() },
            price: "$ " + String(format: "%.2f", Double(selectedVariation.price) / 100.0),
            frameColor: selectedVariation.frameColor,
            lenseColor: selectedVariation.lenseColor,
            selectedColorIndex: currentVariationIndex,
            description: product.details,
            imageData: selectedVariation.imageData ?? [])
    }
    
    private func errorHandler(_ error: Error) async {
        await view?.displayError(title: "Error", message: error.localizedDescription)
    }
}
