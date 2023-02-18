//
//  Product.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

typealias Cent = Int

struct Product {
    enum Category: String { case sunglasses, eyeglasses }
    enum Gender: String { case male, female, unisex, child }
    enum Style: String { case aviator, round, clubmaster, wayfarer, ferrari, erika, justin }

    let modelID: String
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
    let productID: Int
    let price: Cent
    let frameColor: String
    let lenseColor: String
    var imageData: [Data]?
}

extension Product: Codable {}
extension Product.Category: Codable {}
extension Product.Gender: Codable {}
extension Product.Style: Codable {}
extension ProductVariation: Codable {}
