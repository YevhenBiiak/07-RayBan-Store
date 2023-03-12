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
    @discardableResult
    func execute(_ request: CreateOrderRequest) async throws -> Order
    func execute(_ request: ShippingMethodsRequest) async throws -> [ShippingMethod]
}

class CartUseCaseImpl {
    
    private let cartGateway: CartGateway
    private let orderGateway: OrderGateway
    
    init(cartGateway: CartGateway, orderGateway: OrderGateway) {
        self.cartGateway = cartGateway
        self.orderGateway = orderGateway
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
        return cart.orderSummary(shippingMethod: request.shippingMethod)
    }
    
    func execute(_ request: CreateOrderRequest) async throws -> Order {
        try Validator.validateFirstName(request.deliveryInfo.firstName)
        try Validator.validateLastName(request.deliveryInfo.lastName)
        try Validator.validateEmail(request.deliveryInfo.emailAddress)
        try Validator.validatePhone(request.deliveryInfo.phoneNumber)
        try Validator.validateAddress(request.deliveryInfo.shippingAddress)
        
        // fetch cart items, create cart with cart items, create order with request params
        let cartItems = try await cartGateway.fetchCartItems(for: request.user, includeImages: false)
        let cart = Cart(items: cartItems)
        let newOrder = cart.createOrder(deliveryInfo: request.deliveryInfo, shippingMethod: request.shippingMethod)
        
        // fetch orders, create order list, add created order to list
        let orders = try await orderGateway.fetchOrders(for: request.user)
        var orderList = OrderList(orders: orders)
        orderList.add(order: newOrder)
        
        // save order list, clear cart
        try await orderGateway.saveOrders(orderList.orders, for: request.user)
        try await cartGateway.saveCartItems([], for: request.user)
        
        return newOrder
    }
    
    func execute(_ request: ShippingMethodsRequest) async throws -> [ShippingMethod] {
        try await cartGateway.fetchShippingMethods()
    }
}
