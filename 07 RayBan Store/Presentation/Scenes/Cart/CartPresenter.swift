//
//  CartPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 25.02.2023.
//

import Foundation

@MainActor
protocol CartRouter {
    func presentCart()
}

@MainActor
protocol CartView: AnyObject {
    func display(title: String)
    func display(cartSection: any Sectionable)
    func displayError(title: String, message: String?)
}

protocol CartPresenter {
    func viewDidLoad() async
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
            await display(cartItems: cartItems)
        }
    }
}

// MARK: - Private extension

private extension CartPresenterImpl {
    
    private func display(cartItems: [CartItem]) async {
        let viewModels = cartItems.map { createViewModel(with: $0) }
        let items = viewModels.map { CartSectionItem(viewModel: $0) }
        let section = CartSection(items: items)
        await view?.display(cartSection: section)
    }
    
    private func createViewModel(with cartItem: CartItem) -> CartItemCellViewModel? {
        guard let variation = cartItem.product.variations.first else { return nil }
        return CartItemCellViewModel(
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
    
    private func updateCartItem(productID: ProductID, amount: Int) async {
        await with(errorHandler) {
            let requset = UpdateCartItemRequest(user: Session.shared.user, productID: productID, amount: amount)
            let cartItems = try await cartUseCase.execute(requset)
            await display(cartItems: cartItems)
        }
    }
    
    private func deleteCartItem(productID: ProductID) async {
        await with(errorHandler) {
            let request = DeleteCartItemRequest(user: Session.shared.user, productID: productID)
            let cartItems = try await cartUseCase.execute(request)
            await display(cartItems: cartItems)
        }
    }
    
    private func errorHandler(_ error: Error) async {
        await view?.displayError(title: error.localizedDescription, message: nil)
    }
}
