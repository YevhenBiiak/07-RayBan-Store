//
//  OrderSummaryModel.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.03.2023.
//

struct CartSummaryModel: CartSummaryViewModel {
    let subtotal: String
    let discount: String
    let total: String
    let checkoutButtonTapped: () async -> Void
}
