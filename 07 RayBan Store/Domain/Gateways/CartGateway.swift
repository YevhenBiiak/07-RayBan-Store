//
//  CartGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

protocol CartGateway {
    func fetchCartItems(byUserId userId: String, completionHandler: @escaping (Result<[CartItemDTO]>) -> Void)
    func saveCartItems(_ items: [CartItemDTO], forUserId userId: String, completionHandler: @escaping (Result<[CartItemDTO]>) -> Void)
}
