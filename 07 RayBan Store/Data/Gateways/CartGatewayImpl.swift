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
    
    init(cartAPI: CartItemsAPI, productGateway: ProductGateway) {
        self.cartAPI = cartAPI
        self.productGateway = productGateway
    }
}

extension CartGatewayImpl: CartGateway {
    
    func fetchCartItems(for user: User, includeImages: Bool) async throws -> [CartItem] {
        let items = try await cartAPI.fetchCartItems(for: user)
        var cartItems: [CartItem?] = Array(repeating: nil, count: items.count)
        try await withThrowingTaskGroup(of: (index: Int, product: Product).self) { taskGroup in
            
            for (i, item) in items.enumerated() {
                taskGroup.addTask {
                    let product = try await self.productGateway.fetchProduct(productID: item.productID, includeImages: includeImages)
                    return (index: i, product: product)
                }
            }
            for try await (i, product) in taskGroup {
                cartItems[i] = CartItem(product: product, amount: items[i].amount)
            }
        }
        return cartItems.compactMap{$0}
    }
    
    func saveCartItems(_ items: [CartItem], for user: User) async throws {
        try await cartAPI.saveCartItems(items, for: user)
    }
    
    func saveOrder(_ order: Order, for user: User) async throws {
        
    }
}
