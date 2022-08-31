//
//  Order.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import Foundation

struct Order {
    let id: String
    let userId: String
    let items: [OrderItem]
    let shippingMethods: String
    let shippindAddress: String
    let price: Cents
}

// MARK: - Order Item

struct OrderItem {
    let products: Product
    let amount: Int
    let price: Cents
}
