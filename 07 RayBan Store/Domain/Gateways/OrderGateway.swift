//
//  OrderGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.09.2022.
//

import Foundation

protocol OrderGateway {
    func fetchOrders(byUserId userId: String, first: Int, skip: Int, completionHandler: @escaping (Result<[OrderDTO]>) -> Void)
    func createOrder(_ order: OrderDTO, forUserId userId: String, completionHandler: @escaping (Result<OrderDTO>) -> Void)
}
