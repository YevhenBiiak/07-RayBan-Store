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
}
