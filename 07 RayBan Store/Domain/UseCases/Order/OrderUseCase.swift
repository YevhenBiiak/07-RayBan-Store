//
//  OrderUseCase.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.03.2023.
//

import Foundation

protocol OrderUseCase {
    func execute(_ request: OrdersRequest) async throws -> [Order]
    @discardableResult
    func execute(_ request: DeleteOrderRequest) async throws -> [Order]
    func execute(_ request: OrderSummaryRequest) async throws -> OrderSummary
    @discardableResult
    func execute(_ request: CreateOrderRequest) async throws -> Order
    func execute(_ request: ShippingMethodsRequest) async throws -> [ShippingMethod]
}

class OrderUseCaseImpl {
    
    private let orderGateway: OrderGateway
    
    init(orderGateway: OrderGateway) {
        self.orderGateway = orderGateway
    }
}

extension OrderUseCaseImpl: OrderUseCase {

    func execute(_ request: OrdersRequest) async throws -> [Order] {
        try await orderGateway.fetchOrders(for: request.user, options: .image(res: .low))
    }
    
    func execute(_ request: DeleteOrderRequest) async throws -> [Order] {
        let orders = try await orderGateway.fetchOrders(for: request.user, options: .image(res: .low))
        var orderList = OrderList(orders: orders)
        orderList.delete(orderID: request.orderID)
        
        try await orderGateway.saveOrders(orderList.orders, for: request.user)
        return orderList.orders
    }
    
    func execute(_ request: OrderSummaryRequest) async throws -> OrderSummary {
        let cart = Cart(items: request.cartItems)
        return cart.orderSummary(shippingMethod: request.shippingMethod)
    }
    
    func execute(_ request: CreateOrderRequest) async throws -> Order {
        try Validator.validateFirstName(request.deliveryInfo.firstName)
        try Validator.validateLastName(request.deliveryInfo.lastName)
        try Validator.validateEmail(request.deliveryInfo.emailAddress)
        try Validator.validatePhone(request.deliveryInfo.phoneNumber)
        try Validator.validateAddress(request.deliveryInfo.shippingAddress)
        
        // create cart with cart items, create order with request params
        let cart = Cart(items: request.cartItems)
        let newOrder = cart.createOrder(deliveryInfo: request.deliveryInfo, shippingMethod: request.shippingMethod)
        
        // fetch orders, create order list, add created order to list
        let orders = try await orderGateway.fetchOrders(for: request.user, options: .noImages)
        var orderList = OrderList(orders: orders)
        orderList.add(order: newOrder)
        
        // save order list, clear cart
        try await orderGateway.saveOrders(orderList.orders, for: request.user)
        try await orderGateway.deleteCartItems(for: request.user)
        
        return newOrder
    }
    
    func execute(_ request: ShippingMethodsRequest) async throws -> [ShippingMethod] {
        try await orderGateway.fetchShippingMethods()
    }
}
