//
//  CartGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

protocol CartGateway {
    var isCartEmpty: Bool { get }
    func add(_ product: Product, completionHandler: @escaping (Result<[CartItem]>) -> Void)
    func delete(productId: String, completionHandler: @escaping (Result<[CartItem]>) -> Void)
    func update(id: String, amount: Int, completionHandler: @escaping (Result<[CartItem]>) -> Void)
    func getItems(completionHandler: @escaping (Result<[CartItem]>) -> Void)
    func createOrder(completionHandler: @escaping (Result<[OrderItem]>) -> Void)
}
