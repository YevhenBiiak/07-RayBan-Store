//
//  OrderGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 16.09.2022.
//

import Foundation

protocol OrderAPI {
    func saveOrders(_ orders: [OrderCodable], for user: User) async throws
    func fetchOrders(for user: User) async throws -> [OrderCodable]
    func fetchShippingMethods() async throws -> [ShippingMethodCodable]
}

class OrderGatewayImpl {
    
    private let orderAPI: OrderAPI
    private let cartGateway: CartGateway
    private let productGateway: ProductGateway
    
    init(orderAPI: OrderAPI, cartGateway: CartGateway, productGateway: ProductGateway) {
        self.orderAPI = orderAPI
        self.cartGateway = cartGateway
        self.productGateway = productGateway
    }
}

extension OrderGatewayImpl: OrderGateway {
    
    func saveOrders(_ orders: [Order], for user: User) async throws {
        let orders = orders.map(OrderCodable.init)
        try await orderAPI.saveOrders(orders, for: user)
    }
    
    func fetchOrders(for user: User) async throws -> [Order] {
        let orders = try await orderAPI.fetchOrders(for: user).concurrentMap { order in
            let items = try await order.items.concurrentMap { [unowned self] item in
                let product = try await productGateway.fetchProduct(productID: item.productID, includeImages: true)
                return OrderItem(product: product, amount: item.amount)
            }
            return Order(
                orderID: order.orderID,
                date: Date(timeIntervalSince1970: TimeInterval(order.date)),
                items: items,
                deliveryInfo: DeliveryInfo(order.deliveryInfo),
                shippingMethod: ShippingMethod(order.shippingMethod),
                summary: OrderSummary(order.summary)
            )
        }
        return orders
    }
    
    func deleteCartItems(for user: User) async throws {
        try await cartGateway.saveCartItems([], for: user)
    }
    
    func fetchShippingMethods() async throws -> [ShippingMethod] {
        try await orderAPI.fetchShippingMethods().map(ShippingMethod.init)
    }
}
