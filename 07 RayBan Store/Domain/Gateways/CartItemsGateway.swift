//
//  CartItemsGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

protocol CartItemsGateway {
    func fetchCartItems(byCustomerId customerId: String, completionHandler: @escaping (Result<[CartItemDTO]>) -> Void)
    func saveCartItems(_ items: [CartItemDTO], forCustomerId customerId: String, completionHandler: @escaping (Result<[CartItemDTO]>) -> Void)
}
