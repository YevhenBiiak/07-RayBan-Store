//
//  Order.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import Foundation

typealias OrderItem = CartItem
typealias OrderID = String

struct OrderList {
    
    var orders: [Order]
    
    mutating func add(order: Order) {
        orders.append(order)
    }
    
    mutating func delete(orderID: OrderID) {
        orders.removeAll { $0.orderID == orderID }
    }
}

struct Order {
    let orderID: OrderID
    let date: Date
    let items: [OrderItem]
    let deliveryInfo: DeliveryInfo
    let shippingMethod: ShippingMethod
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

struct DeliveryInfo {
    let firstName: String
    let lastName: String
    let emailAddress: String
    let phoneNumber: String
    let shippingAddress: String
}
