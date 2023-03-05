//
//  OrderUseCase.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.03.2023.
//

import Foundation

protocol OrderUseCase {
    func execute(_ request: OrdersRequest) async throws -> [Order]
    func execute(_ request: OrderItemsRequest) async throws -> [OrderItem]
    func execute(_ request: ShippingMethodsRequest) async throws -> [ShippingMethod]
//    @discardableResult
//    func execute(_ request: CreateOrderRequest) async throws -> Order
}

class OrderUseCaseImpl {
    
    private let orderGateway: OrderGateway
    
    init(orderGateway: OrderGateway) {
        self.orderGateway = orderGateway
    }
}

extension OrderUseCaseImpl: OrderUseCase {

    func execute(_ request: OrdersRequest) async throws -> [Order] {
        []
    }
    
    func execute(_ request: OrderItemsRequest) async throws -> [OrderItem] {
        []
    }
    
    func execute(_ request: ShippingMethodsRequest) async throws -> [ShippingMethod] {
        try await orderGateway.fetchShippingMethods()
    }
    
//    func execute(_ request: CreateOrderRequest) async throws -> Order {
//        let cartItems = try await cartGateway.fetchCartItems(for: request.user, includeImages: true)
//        let cart = Cart(items: cartItems)
//        let order = cart.createOrder(shippindAddress: request.shippingAddress, shippingMethods: request.shippingMethods)
//
//        try await cartGateway.saveOrder(order, for: request.user)
//        return order
//    }
}
