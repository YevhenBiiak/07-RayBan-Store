//
//  ProductCellViewModel.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 22.09.2022.
//

import Foundation

struct ProductsSection: Sectionable {
    var header: String?
    var items: [any Itemable]
}
struct ProductItem: Itemable {
    var viewModel: ProductCellViewModel?
}

struct ProductCellViewModel {
    let productID: Int
    let isNew: Bool
    let isInCart: Bool
    let name: String
    let price: String
    let colors: String
    let imageData: Data
    let index: Int
    let addButtonTapped: (ProductCellViewModel) async -> Void
    let cartButtonTapped: () async -> Void
}
