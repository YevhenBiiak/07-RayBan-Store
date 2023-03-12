//
//  CartItemCodable.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 12.03.2023.
//

struct CartItemCodable: Codable {
    let productID: Int
    let amount: Int
}

extension CartItemCodable {
    init(_ model: CartItem) {
        self.productID = model.product.variations.first!.productID
        self.amount = model.amount
    }
}
