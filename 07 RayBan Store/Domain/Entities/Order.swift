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
    let shippingMethods: String
    let shippindAddress: String
    let price: Cent
}
