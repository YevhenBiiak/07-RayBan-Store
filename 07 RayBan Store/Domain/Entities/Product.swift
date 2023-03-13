//
//  Product.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

typealias Cent = Int
typealias ModelID = String
typealias ProductID = Int

struct Product {
    enum Category: String { case sunglasses, eyeglasses }
    enum Gender: String { case male, female, unisex, kids }
    enum Style: String { case aviator, round, clubmaster, wayfarer, ferrari, erika, justin }

    let modelID: ModelID
    let name: String
    let style: Style
    let gender: Gender
    let category: Category
    let size: String
    let geofit: String
    let details: String
    var variations: [ProductVariation]
}

struct ProductVariation {
    let productID: ProductID
    let price: Cent
    let frameColor: String
    let lenseColor: String
    var imageData: [Data]?
}
