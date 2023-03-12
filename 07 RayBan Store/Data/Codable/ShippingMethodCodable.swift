//
//  ShippingMethodCodable.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 12.03.2023.
//

struct ShippingMethodCodable: Codable {
    let name: String
    let duration: String
    let price: Int
}

extension ShippingMethodCodable {
    init(_ model: ShippingMethod) {
        self.name = model.name
        self.duration = model.duration
        self.price = model.price
    }
}

extension ShippingMethod {
    init(_ model: ShippingMethodCodable) {
        self.name = model.name
        self.duration = model.duration
        self.price = model.price
    }
}
