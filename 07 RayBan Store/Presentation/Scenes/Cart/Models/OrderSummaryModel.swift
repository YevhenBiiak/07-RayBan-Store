//
//  OrderSummaryModel.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.03.2023.
//

struct OrderSummaryModel: OrderSummaryViewModel {
    let subtotal: String
    let shipping: String
    let total: String
    let checkoutButtonTapped: () async -> Void
}
