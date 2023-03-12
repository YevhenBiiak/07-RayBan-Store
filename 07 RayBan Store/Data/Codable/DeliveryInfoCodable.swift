//
//  DeliveryInfoCodable.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 12.03.2023.
//

struct DeliveryInfoCodable: Codable {
    let firstName: String
    let lastName: String
    let emailAddress: String
    let phoneNumber: String
    let shippingAddress: String
}

extension DeliveryInfoCodable {
    init(_ model: DeliveryInfo) {
        self.firstName = model.firstName
        self.lastName = model.lastName
        self.emailAddress = model.emailAddress
        self.phoneNumber = model.phoneNumber
        self.shippingAddress = model.shippingAddress
    }
}

extension DeliveryInfo {
    init(_ model: DeliveryInfoCodable) {
        self.firstName = model.firstName
        self.lastName = model.lastName
        self.emailAddress = model.emailAddress
        self.phoneNumber = model.phoneNumber
        self.shippingAddress = model.shippingAddress
    }
}
