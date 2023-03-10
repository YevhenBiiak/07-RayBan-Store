//
//  CartGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

protocol CartItemsAPI {
    func fetchCartItems(for user: User) async throws -> [(productID: Int, amount: Int)]
    func saveCartItems(_ cartItems: [CartItem], for user: User) async throws
}

class CartGatewayImpl {
    
    private let cartAPI: CartItemsAPI
    private let productGateway: ProductGateway
    private let orderGateway: OrderGateway
    
    init(cartAPI: CartItemsAPI, productGateway: ProductGateway, orderGateway: OrderGateway) {
        self.cartAPI = cartAPI
        self.productGateway = productGateway
        self.orderGateway = orderGateway
    }
}

extension CartGatewayImpl: CartGateway {
    
    func fetchCartItems(for user: User, includeImages: Bool) async throws -> [CartItem] {
        let items = try await cartAPI.fetchCartItems(for: user)
        let cartItems = try await items.concurrentMap { [unowned self] productID, amount in
            let product = try await productGateway.fetchProduct(productID: productID, includeImages: includeImages)
            return CartItem(product: product, amount: amount)
        }
        return cartItems
    }
    
    func saveCartItems(_ items: [CartItem], for user: User) async throws {
        try await cartAPI.saveCartItems(items, for: user)
    }
    
    func saveOrder(_ order: Order, for user: User) async throws {
        try await orderGateway.saveOrder(order, for: user)
    }
}
