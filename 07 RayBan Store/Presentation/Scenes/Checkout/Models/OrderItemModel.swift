//
//  OrderItemModel.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 08.03.2023.
//

import Foundation

struct OrderItemsSection: Sectionable {
    var header: String?
    var items: [any Itemable]
}

struct OrderSectionItem: Itemable {
    var viewModel: OrderItemViewModel?
}

struct OrderItemModel: OrderItemViewModel {
    let productID: Int
    let name: String
    let price: String
    let quantity: String
    let imageData: Data
}
