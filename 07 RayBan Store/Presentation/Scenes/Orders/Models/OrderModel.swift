//
//  OrderModel.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 11.03.2023.
//

struct OrderModel: OrderViewModel {
    let date: String
    let items: [OrderItemViewModel]
    let total: String
    let deleteOrderButtonTapped: () async -> Void
    let addToCartButtonTapped: () async -> Void
}
