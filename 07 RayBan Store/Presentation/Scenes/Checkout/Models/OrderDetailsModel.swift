//
//  OrderDetailsModel.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 08.03.2023.
//

import Foundation

struct OrderDetailsModel: OrderDetailsViewModel {
    var shippingMethods: [ShippingMethodViewModel]
    let subtotal: String
    let shippingCost: String
    let total: String
}

struct ShippingMethodModel: ShippingMethodViewModel {
    let name: String
    let duration: String
    let price: String
    let isSelected: Bool
    let didSelectMethod: () async -> Void
}
