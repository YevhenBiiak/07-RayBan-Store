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
    func presentCheckout(shippingMethod: ShippingMethod)
}

@MainActor
protocol CartView: AnyObject {
    func display(title: String)
    func display(cartSection: any Sectionable)
    func display(shippingMethods: [any ShippingMethodViewModel])
    func display(orderSummary: OrderSummaryViewModel)
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
    
    private var selectedShipping: ShippingMethod!
    
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
    
    private func display(cartItems: [CartItem]) async throws {
        let viewModels = cartItems.map(createCartItemModel)
        let items = viewModels.map(CartSectionItem.init)
        let section = CartSection(items: items)
        await view?.display(cartSection: section)
        
        try await displayShippingMethods()
        try await displayOrderSummary()
    }
    
    private func displayShippingMethods() async throws {
        let shippingRequest = ShippingMethodsRequest(user: Session.shared.user)
        let shippingMethods = try await cartUseCase.execute(shippingRequest)
        if selectedShipping == nil { selectedShipping = shippingMethods.first }
        let shippingMethodModels = shippingMethods.map(createShippingMethodModel)
        await view?.display(shippingMethods: shippingMethodModels)
    }
    
    private func displayOrderSummary() async throws {
        let summaryRequest = OrderSummaryRequest(user: Session.shared.user, shippingMethod: selectedShipping)
        let summary = try await cartUseCase.execute(summaryRequest)
        let orderSummary = createOrderSummaryModel(with: summary)
        await view?.display(orderSummary: orderSummary)
    }
    
    private func createCartItemModel(with cartItem: CartItem) -> CartItemModel? {
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
    
    private func createShippingMethodModel(with shippingMethod: ShippingMethod) -> ShippingMethodModel {
        ShippingMethodModel(
            title: shippingMethod.name,
            subtitle: shippingMethod.duration,
            price: shippingMethod.price == 0 ? "FREE" : "$ " + String(format: "%.2f", Double(shippingMethod.price) / 100.0),
            isSelected: shippingMethod == selectedShipping,
            didSelectMethod: { [weak self] in
                await self?.didSelectShippingMethod(shippingMethod)
            }
        )
    }
    
    private func createOrderSummaryModel(with summary: OrderSummary) -> OrderSummaryModel {
        OrderSummaryModel(
            subtotal: "$ " + String(format: "%.2f", Double(summary.subtotal) / 100.0),
            shipping: "$ " + String(format: "%.2f", Double(summary.shipping) / 100.0),
            total: "$ " + String(format: "%.2f", Double(summary.total) / 100.0),
            checkoutButtonTapped: { [weak self] in
                guard let self else { return }
                await self.router.presentCheckout(shippingMethod: self.selectedShipping)
            }
        )
    }
    
    private func updateCartItem(productID: ProductID, amount: Int) async {
        await with(errorHandler) {
            let requset = UpdateCartItemRequest(user: Session.shared.user, productID: productID, amount: amount)
            let cartItems = try await cartUseCase.execute(requset)
            try await display(cartItems: cartItems)
        }
    }
    
    private func deleteCartItem(productID: ProductID) async {
        await with(errorHandler) {
            let request = DeleteCartItemRequest(user: Session.shared.user, productID: productID)
            let cartItems = try await cartUseCase.execute(request)
            try await display(cartItems: cartItems)
        }
    }
    
    private func didSelectShippingMethod(_ shippingMethod: ShippingMethod) async {
        await with(errorHandler) {
            selectedShipping = shippingMethod
            try await displayShippingMethods()
            try await displayOrderSummary()
        }
    }
    
    private func errorHandler(_ error: Error) async {
        await view?.displayError(title: "Error", message: error.localizedDescription)
    }
}
