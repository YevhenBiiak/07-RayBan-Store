//
//  ProductCodable.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 13.03.2023.
//

import Foundation

struct ProductCodable {
    enum CategoryCodable: String { case sunglasses, eyeglasses }
    enum GenderCodable: String { case male, female, unisex, kids }
    enum StyleCodable: String { case aviator, round, clubmaster, wayfarer, ferrari, erika, justin }
    
    let modelID: String
    let name: String
    let style: StyleCodable
    let gender: GenderCodable
    let category: CategoryCodable
    let size: String
    let geofit: String
    let details: String
    var variations: [ProductVariationCodable]
}

struct ProductVariationCodable {
    let productID: Int
    let price: Int
    let frameColor: String
    let lenseColor: String
    var imageData: [Data]?
}

extension ProductCodable: Codable {}
extension ProductCodable.CategoryCodable: Codable {}
extension ProductCodable.GenderCodable: Codable {}
extension ProductCodable.StyleCodable: Codable {}
extension ProductVariationCodable: Codable {}

extension Product {
    init(_ model: ProductCodable) {
        self.modelID = model.modelID
        self.name = model.name
        self.style = Product.Style(model.style)
        self.gender = Product.Gender(model.gender)
        self.category = Product.Category(model.category)
        self.size = model.size
        self.geofit = model.geofit
        self.details = model.details
        self.variations = model.variations.map(ProductVariation.init)
    }
}

extension ProductVariation {
    init(_ model: ProductVariationCodable) {
        self.productID = model.productID
        self.price = model.price
        self.frameColor = model.frameColor
        self.lenseColor = model.lenseColor
        self.imageData = model.imageData
    }
}

extension Product.Category {
    init(_ model: ProductCodable.CategoryCodable) {
        switch model {
        case .sunglasses:
            self = .sunglasses
        case .eyeglasses:
            self = .eyeglasses
        }
    }
}

extension Product.Gender {
    init(_ model: ProductCodable.GenderCodable) {
        switch model {
        case .male:
            self = .male
        case .female:
            self = .female
        case .unisex:
            self = .unisex
        case .kids:
            self = .kids
        }
    }
}

extension Product.Style {
    init(_ model: ProductCodable.StyleCodable) {
        switch model {
        case .aviator:
            self = .aviator
        case .round:
            self = .round
        case .clubmaster:
            self = .clubmaster
        case .wayfarer:
            self = .wayfarer
        case .ferrari:
            self = .ferrari
        case .erika:
            self = .erika
        case .justin:
            self = .justin
        }
    }
}
