//
//  OrderGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.09.2022.
//

import Foundation

protocol OrderGateway {
    func fetchOrders(byCustomerId customerId: String, completionHandler: @escaping (Result<[OrderDTO]>) -> Void)
    func saveOrder(_ order: OrderDTO, forCustomerId customerId: String, completionHandler: @escaping (Result<OrderDTO>) -> Void)
}
