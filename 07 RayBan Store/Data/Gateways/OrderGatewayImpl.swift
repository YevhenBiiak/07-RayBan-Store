//
//  OrderGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 16.09.2022.
//

import Foundation

protocol OrderAPI {
    func fetchShippingMethods() async throws -> [ShippingMethod]
    func saveOrder(_ order: Order, for user: User) async throws
}

class OrderGatewayImpl {
    
    private let orderAPI: OrderAPI
    
    init(orderApi: OrderAPI) {
        self.orderAPI = orderApi
    }
}

extension OrderGatewayImpl: OrderGateway {
    
    func fetchShippingMethods() async throws -> [ShippingMethod] {
        try await orderAPI.fetchShippingMethods()
    }
    
    func fetchOrders(for user: User) async throws -> [Order] {
        []
    }
    
    func saveOrder(_ order: Order, for user: User) async throws {
        try await orderAPI.saveOrder(order, for: user)
    }
}
