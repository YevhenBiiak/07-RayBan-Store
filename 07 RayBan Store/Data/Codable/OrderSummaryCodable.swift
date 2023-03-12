//
//  OrderSummaryCodable.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 12.03.2023.
//

struct OrderSummaryCodable: Codable {
    let subtotal: Int
    let shipping: Int
    let total: Int
}

extension OrderSummaryCodable {
    init(_ model: OrderSummary) {
        self.subtotal = model.subtotal
        self.shipping = model.shipping
        self.total = model.total
    }
}

extension OrderSummary {
    init(_ model: OrderSummaryCodable) {
        self.subtotal = model.subtotal
        self.shipping = model.shipping
        self.total = model.total
    }
}
