//
//  Product.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

typealias Cent = Int

struct Product {
    let id: String
    let name: String
    let type: String
    let family: String
    let gender: String
    let size: String
    let geofit: String
    let variations: [ProductVariant]
    let details: String
}

struct ProductVariant {
    let frameColor: String
    let lenseColor: String
    let price: Cent
    let imgId: Int
}
