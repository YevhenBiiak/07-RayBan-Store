//
//  ShippingMethodModel.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 28.02.2023.
//

struct ShippingMethodModel: ShippingMethodViewModel {
    let title: String
    let subtitle: String
    let price: String
    let isSelected: Bool
    let didSelectMethod: () async -> Void
}
