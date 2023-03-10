//
//  CartItemModel.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 28.02.2023.
//

import Foundation

struct CartSection: Sectionable {
    var header: String?
    var items: [any Itemable]
}

struct CartSectionItem: Itemable {
    var viewModel: CartItemViewModel?
}

struct CartItemModel: CartItemViewModel {
    let productID: Int
    let quantity: Int
    let name: String
    let price: String
    let frame: String
    let lense: String
    let size: String
    let imageData: Data
    let itemAmountDidChange: (ProductID, Int) async -> Void
    let deleteItemButtonTapped: (ProductID) async -> Void
}
