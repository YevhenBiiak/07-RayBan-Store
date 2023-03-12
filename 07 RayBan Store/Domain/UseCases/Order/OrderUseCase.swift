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
}

class OrderUseCaseImpl {
    
    private let orderGateway: OrderGateway
    
    init(orderGateway: OrderGateway) {
        self.orderGateway = orderGateway
    }
}

extension OrderUseCaseImpl: OrderUseCase {

    func execute(_ request: OrdersRequest) async throws -> [Order] {
        try await orderGateway.fetchOrders(for: request.user)
    }
    
    func execute(_ request: DeleteOrderRequest) async throws -> [Order] {
        let orders = try await orderGateway.fetchOrders(for: request.user)
        var orderList = OrderList(orders: orders)
        orderList.delete(orderID: request.orderID)
        
        try await orderGateway.saveOrders(orderList.orders, for: request.user)
        return orderList.orders
    }
}
