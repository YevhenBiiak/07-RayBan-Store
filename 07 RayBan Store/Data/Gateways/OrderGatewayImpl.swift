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
    private let profileGateway: ProfileGateway
    
    init(orderAPI: OrderAPI, profileGateway: ProfileGateway) {
        self.orderAPI = orderAPI
        self.profileGateway = profileGateway
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
        
        var profile = try await profileGateway.fetchProfile(for: user)
        profile.phone = order.deliveryInfo.phoneNumber
        profile.address = order.deliveryInfo.shippingAddress
        try await profileGateway.saveProfile(profile)
    }
}
