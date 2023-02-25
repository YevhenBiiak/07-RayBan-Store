//
//  ProductDetailsPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 18.09.2022.
//

import Foundation

protocol ProductDetailsRouter {
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
    func didSelectColorSegment(at index: Int) async
    func addToCartButtonTapped(productID: Int) async
    func favoriteButtonTapped(isFavorite: Bool) async
    func cartButtonTapped() async
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
            // display product with single main image
            try await displayUpdatedViewModel()
            
            // display cart badge
            let isCartEmptyRequest = IsCartEmptyRequest(user: Session.shared.user)
            let isCartEmpty = try await cartUseCase.execute(isCartEmptyRequest)
            isCartEmpty ? await view?.hideCartBadge() : await view?.displayCartBadge()
            
            // load and display all images for first product variation
            let productIDRequest = ProductWithIDRequest(productID: product.variations[0].productID)
            product.variations[0] = try await getProductsUseCase.execute(productIDRequest).variations[0]
            try await displayUpdatedViewModel()
            
            // load all images for variations and display selected
            let request = ProductWithModelIDRequest(modelID: product.modelID)
            product = try await getProductsUseCase.execute(request)
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
            let productRequest = ProductWithIDRequest(productID: productID)
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
                let request = DeleteFavoriteItemRequest(user: Session.shared.user, modelID: product.modelID, includeImages: false)
                try await favoriteUseCase.execute(request)
            }
        }
    }
    
    func cartButtonTapped() async {
//        await view?.displayCartBadge()
    }
}

// MARK: - Private methods

extension ProductDetailsPresenterImpl {
    
    private func displayUpdatedViewModel() async throws {
        let viewModel = try await createProductViewModel(with: product)
        await view?.display(viewModel: viewModel)
    }
    
    private func createProductViewModel(with product: Product) async throws -> ProductDetailsViewModel {
        let selectedVariation = product.variations[currentVariationIndex]
        
        let inCartRequest = IsProductInCartRequset(user: Session.shared.user, product: product)
        let isInCart = try await cartUseCase.execute(inCartRequest)
        
        let inFavoriteRequest = IsItemInFavoriteRequset(user: Session.shared.user, product: product)
        let isInFavorite = try await favoriteUseCase.execute(inFavoriteRequest)
        
        return ProductDetailsViewModel(
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
        await view?.displayError(title: error.localizedDescription, message: nil)
    }
}
