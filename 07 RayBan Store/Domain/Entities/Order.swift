//
//  Order.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import Foundation

typealias OrderItem = CartItem

struct Order {
    let items: [OrderItem]
    let shippindAddress: String
    let shippingMethods: ShippingMethod
    let summary: OrderSummary
}

struct OrderSummary {
    let subtotal: Cent
    let shipping: Cent
    let total: Cent
}

struct ShippingMethod: Hashable {
    let name: String
    let duration: String
    let price: Cent
}
