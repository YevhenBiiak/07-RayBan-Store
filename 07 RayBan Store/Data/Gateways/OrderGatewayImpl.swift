//
//  OrderGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 16.09.2022.
//

import Foundation

protocol OrderAPI {
    func fetchShippingMethods() async throws -> [ShippingMethod]
}

class OrderGatewayImpl: OrderGateway {
    
    private let orderApi: OrderAPI
    
    init(orderApi: OrderAPI) {
        self.orderApi = orderApi
    }
    
    func fetchShippingMethods() async throws -> [ShippingMethod] {
        try await orderApi.fetchShippingMethods()
    }
    
}
