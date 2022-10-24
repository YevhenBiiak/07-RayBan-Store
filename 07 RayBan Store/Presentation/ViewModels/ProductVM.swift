//
//  ProductVM.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 22.09.2022.
//

import UIKit

struct ProductVM {
    let id: String
    let nameLabel: String
    let type: String
    let family: String
    let gender: String
    let size: String
    let geofit: String
    let colorsLabel: String
    let variations: [ProductVariantVM]
    let details: String
    var images: [UIImage]
}

struct ProductVariantVM {
    let priceLabel: String
    let frameColor: String
    let lenseColor: String
    let priceInCents: Int
    var color: String
    let imageId: Int
}

extension ProductVM: Hashable {
    static func == (lhs: ProductVM, rhs: ProductVM) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension ProductVariantVM: Hashable {
    static func == (lhs: ProductVariantVM, rhs: ProductVariantVM) -> Bool {
        lhs.imageId == rhs.imageId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(imageId)
    }
}
