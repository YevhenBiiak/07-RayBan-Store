//
//  OrderDetailsModel.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 08.03.2023.
//

import Foundation

struct OrderDetailsModel: OrderDetailsViewModel {
    let shippingTitle: String
    let shippingSubtitle: String
    let shippingPrice: String
    let orderSubtotal: String
    let orderShippingCost: String
    let orderTotal: String
}
