//
//  CartGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

protocol CartAPI {
    func fetchCartItems(for user: User) async throws -> [CartItemCodable]
    func saveCartItems(_ items: [CartItemCodable], for user: User) async throws
}

class CartGatewayImpl {
    
    private let cartAPI: CartAPI
    private let productGateway: ProductGateway
    
    init(cartAPI: CartAPI, productGateway: ProductGateway) {
        self.cartAPI = cartAPI
        self.productGateway = productGateway
    }
}

extension CartGatewayImpl: CartGateway {
    
    func fetchCartItems(for user: User, includeImages: Bool) async throws -> [CartItem] {
        let items = try await cartAPI.fetchCartItems(for: user)
        let cartItems = try await items.concurrentMap { [unowned self] item in
            let product = try await productGateway.fetchProduct(productID: item.productID, includeImages: includeImages)
            return CartItem(product: product, amount: item.amount)
        }
        return cartItems
    }
    
    func saveCartItems(_ items: [CartItem], for user: User) async throws {
        let items = items.map(CartItemCodable.init)
        try await cartAPI.saveCartItems(items, for: user)
    }
}
