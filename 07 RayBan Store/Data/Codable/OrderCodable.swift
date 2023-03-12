//
//  OrderCodable.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 12.03.2023.
//

import Foundation

typealias OrderItemCodable = CartItemCodable

struct OrderCodable: Codable {
    let orderID: String
    let date: Int
    let items: [OrderItemCodable]
    let deliveryInfo: DeliveryInfoCodable
    let shippingMethod: ShippingMethodCodable
    let summary: OrderSummaryCodable
}

extension OrderCodable {
    init(_ model: Order) {
        self.orderID = model.orderID
        self.date = Int(model.date.timeIntervalSince1970)
        self.items = model.items.map(OrderItemCodable.init)
        self.summary = OrderSummaryCodable.init(model.summary)
        self.shippingMethod = ShippingMethodCodable(model.shippingMethod)
        self.deliveryInfo = DeliveryInfoCodable(model.deliveryInfo)
    }
}
