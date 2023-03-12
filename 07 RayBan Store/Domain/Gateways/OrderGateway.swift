//
//  OrderGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.09.2022.
//

import Foundation

protocol OrderGateway {
    func fetchOrders(for user: User) async throws -> [Order]
    func saveOrders(_ orders: [Order], for user: User) async throws
}
