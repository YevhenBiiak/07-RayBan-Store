//
//  CartPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 25.02.2023.
//

import Foundation

@MainActor
protocol CartRouter {
    func presentProductDetails(product: Product)
    func presentCheckout(cartItems: [CartItem])
}

@MainActor
protocol CartView: AnyObject {
    func display(title: String)
    func display(cartSection: any Sectionable)
    func display(cartSummary: CartSummaryViewModel)
    func displayError(title: String, message: String?)
}

protocol CartPresenter {
    func viewDidLoad() async
    func didSelectItem(_ item: any Itemable) async
}

class CartPresenterImpl {
    
    private weak var view: CartView?
    private let router: CartRouter
    private let cartUseCase: CartUseCase
    
    init(view: CartView?, router: CartRouter, cartUseCase: CartUseCase) {
        self.view = view
        self.router = router
        self.cartUseCase = cartUseCase
    }
}

extension CartPresenterImpl: CartPresenter {
    
    func viewDidLoad() async {
        await with(errorHandler) {
            await view?.display(title: "SHOPPING BAG")
            let request = GetCartItemsRequest(user: Session.shared.user)
            let cartItems = try await cartUseCase.execute(request)
            try await display(cartItems: cartItems)
        }
    }
    
    func didSelectItem(_ item: any Itemable) async {
        await with(errorHandler) {
            guard let viewModel = (item as? CartSectionItem)?.viewModel else { return }
            let request = GetCartItemsRequest(user: Session.shared.user)
            let cartItems = try await cartUseCase.execute(request)
            guard let cartItem = cartItems.first(where: {
                $0.product.variations.contains(where: { $0.productID == viewModel.productID})
            }) else { return }
            await router.presentProductDetails(product: cartItem.product)
        }
    }
}

// MARK: - Private extension

private extension CartPresenterImpl {
    
    func display(cartItems: [CartItem]) async throws {
        let viewModels = cartItems.map(createCartItemModel)
        let items = viewModels.map(CartSectionItem.init)
        let section = CartSection(items: items)
        await view?.display(cartSection: section)
        try await displayCartSummary()
    }
    
    func displayCartSummary() async throws {
        let request = GetCartItemsRequest(user: Session.shared.user)
        let cartItems = try await cartUseCase.execute(request)
        let summaryRequest = CartSummaryRequest(user: Session.shared.user, cartItems: cartItems)
        let summary = try await cartUseCase.execute(summaryRequest)
        let summaryModel = createCartSummaryModel(with: summary)
        await view?.display(cartSummary: summaryModel)
    }
    
    func createCartItemModel(with cartItem: CartItem) -> CartItemModel? {
        guard let variation = cartItem.product.variations.first else { return nil }
        return CartItemModel(
            productID: variation.productID,
            quantity: cartItem.amount,
            name: cartItem.product.name.uppercased(),
            price: "$ " + String(format: "%.2f", Double(variation.price) / 100.0),
            frame: "Frame color: \(variation.frameColor)",
            lense: "Lense color: \(variation.lenseColor)",
            size: "Size: \(cartItem.product.size)",
            imageData: variation.imageData?.first ?? Data(),
            itemAmountDidChange: { [weak self] productID, amount in
                await self?.updateCartItem(productID: productID, amount: amount)
            }, deleteItemButtonTapped: { [weak self] productID in
                await self?.deleteCartItem(productID: productID)
            }
        )
    }
    
    func createCartSummaryModel(with summary: CartSummary) -> CartSummaryModel {
        .init(
            subtotal: "$ " + String(format: "%.2f", Double(summary.subtotal) / 100.0),
            discount: "$ " + String(format: "%.2f", Double(summary.discount) / 100.0),
            total: "$ " + String(format: "%.2f", Double(summary.total) / 100.0),
            checkoutButtonTapped: { [weak self] in
                await self?.presentCheckout()
            }
        )
    }
    
    func updateCartItem(productID: ProductID, amount: Int) async {
        await with(errorHandler) {
            let requset = UpdateCartItemRequest(user: Session.shared.user, productID: productID, amount: amount)
            let cartItems = try await cartUseCase.execute(requset)
            try await display(cartItems: cartItems)
        }
    }
    
    func deleteCartItem(productID: ProductID) async {
        await with(errorHandler) {
            let request = DeleteCartItemRequest(user: Session.shared.user, productID: productID)
            let cartItems = try await cartUseCase.execute(request)
            try await display(cartItems: cartItems)
        }
    }
    
    func presentCheckout() async {
        await with(errorHandler) {
            let request = GetCartItemsRequest(user: Session.shared.user)
            let cartItems = try await cartUseCase.execute(request)
            await router.presentCheckout(cartItems: cartItems)
        }
    }
    
    func errorHandler(_ error: Error) async {
        await view?.displayError(title: "Error", message: error.localizedDescription)
    }
}
