//
//  CartUseCase.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 16.02.2023.
//

import Foundation

protocol CartUseCase {
    func execute(_ request: IsCartEmptyRequest) async throws -> Bool
    func execute(_ request: IsProductInCartRequset) async throws -> Bool
    func execute(_ request: GetCartItemsRequest) async throws -> [CartItem]
    @discardableResult
    func execute(_ request: AddCartItemRequest) async throws -> [CartItem]
    @discardableResult
    func execute(_ request: DeleteCartItemRequest) async throws -> [CartItem]
    @discardableResult
    func execute(_ request: UpdateCartItemRequest) async throws -> [CartItem]
    func execute(_ request: OrderSummaryRequest) async throws -> OrderSummary
}

class CartUseCaseImpl {
    
    private let cartGateway: CartGateway
    
    init(cartGateway: CartGateway) {
        self.cartGateway = cartGateway
    }
}

extension CartUseCaseImpl: CartUseCase {
    
    func execute(_ request: IsCartEmptyRequest) async throws -> Bool {
        let cartItems = try await cartGateway.fetchCartItems(for: request.user, includeImages: false)
        let cart = Cart(items: cartItems)
        return cart.isCartEmpty
    }
    
    func execute(_ request: IsProductInCartRequset) async throws -> Bool {
        let cartItems = try await cartGateway.fetchCartItems(for: request.user, includeImages: false)
        let cart = Cart(items: cartItems)
        return cart.contains(request.productID)
    }
    
    func execute(_ request: GetCartItemsRequest) async throws -> [CartItem] {
        let cartItems = try await cartGateway.fetchCartItems(for: request.user, includeImages: true)
        let cart = Cart(items: cartItems)
        return cart.items
    }
    
    func execute(_ request: AddCartItemRequest) async throws -> [CartItem] {
        let cartItems = try await cartGateway.fetchCartItems(for: request.user, includeImages: false)
        var cart = Cart(items: cartItems)
        
        cart.add(product: request.product, amount: request.amount)
        try await cartGateway.saveCartItems(cart.items, for: request.user)
        return cart.items
    }
    
    func execute(_ request: DeleteCartItemRequest) async throws -> [CartItem] {
        let cartItems = try await cartGateway.fetchCartItems(for: request.user, includeImages: true)
        var cart = Cart(items: cartItems)
        
        cart.delete(productID: request.productID)
        try await cartGateway.saveCartItems(cart.items, for: request.user)
        return cart.items
    }
    
    func execute(_ request: UpdateCartItemRequest) async throws -> [CartItem] {
        let cartItems = try await cartGateway.fetchCartItems(for: request.user, includeImages: true)
        var cart = Cart(items: cartItems)
        
        cart.update(productID: request.productID, amount: request.amount)
        try await cartGateway.saveCartItems(cart.items, for: request.user)
        return cart.items
    }
    
    func execute(_ request: OrderSummaryRequest) async throws -> OrderSummary {
        let cartItems = try await cartGateway.fetchCartItems(for: request.user, includeImages: false)
        let cart = Cart(items: cartItems)
        return cart.orderSummary(shippingMethod: request.shippingMethods)
    }
}
