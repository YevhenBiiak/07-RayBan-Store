//
//  CartUseCase.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 16.02.2023.
//

import Foundation

protocol CartUseCase {
    func execute(_ request: IsCartEmptyRequest) async throws -> Bool
    func execute(_ request: GetCartItemsRequest) async throws -> [CartItem]
    func execute(_ request: AddCartItemRequest) async throws -> [CartItem]
    func execute(_ request: DeleteCartItemRequest) async throws -> [CartItem]
    func execute(_ request: UpdateCartItemRequest) async throws -> [CartItem]
    func execute(_ request: CreateOrderRequest) async throws -> Order
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
    
    func execute(_ request: GetCartItemsRequest) async throws -> [CartItem] {
        let cartItems = try await cartGateway.fetchCartItems(for: request.user, includeImages: true)
        let cart = Cart(items: cartItems)
        return cart.items
    }
    
    func execute(_ request: AddCartItemRequest) async throws -> [CartItem] {
        let cartItems = try await cartGateway.fetchCartItems(for: request.user, includeImages: true)
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
    
    func execute(_ request: CreateOrderRequest) async throws -> Order {
        let cartItems = try await cartGateway.fetchCartItems(for: request.user, includeImages: true)
        let cart = Cart(items: cartItems)
        let order = cart.createOrder(shippindAddress: request.shippingAddress, shippingMethods: request.shippingMethods)
        
        try await cartGateway.saveOrder(order, for: request.user)
        
        return order
    }
}
