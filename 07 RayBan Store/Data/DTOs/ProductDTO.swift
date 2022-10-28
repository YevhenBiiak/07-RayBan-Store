//
//  ProductDTO.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import UIKit

struct ProductVariantDTO: Codable, Sendable {
    let frameColor: String
    let lenseColor: String
    var color: String { "\(frameColor)/\(lenseColor)" }
    let price: Int
    let imgId: Int
}

struct ProductDTO: Codable, Sendable {
    let id: String
    let name: String
    let type: String
    let family: String
    let gender: String
    let size: String
    let geofit: String
    let variations: [ProductVariantDTO]
    let details: String
    var images: [Data]?
}

// MARK: - Data mapping from ProductDTO and [ProductDTO]

extension ProductDTO {
    var asProduct: Product {
        Product(
            id: self.id,
            name: self.name,
            type: self.type,
            family: self.family,
            gender: self.gender,
            size: self.size,
            geofit: self.geofit,
            variations: self.variations.asProductVariants,
            details: self.details)
    }
}

extension ProductDTO {
    var asProductVM: ProductVM {
        ProductVM(
            id: self.id,
            nameLabel: self.name.uppercased(),
            type: self.type,
            family: self.family,
            gender: self.gender,
            size: self.size,
            geofit: self.geofit,
            colorsLabel: "\(self.variations.count) COLORS",
            variations: self.variations.asProductVariantsVM,
            details: self.details,
            images: (self.images ?? [])
                        .map({UIImage(data: $0)})
                        .compactMap({$0}) )
    }
}

extension Array where Element == ProductDTO {
    var asProductsVM: [ProductVM] {
        self.map { item in
            item.asProductVM
        }
    }
}

extension Array where Element == ProductDTO {
    var asProductFamilyVM: [ProductFamilyVM] {
        self.map { item in
            ProductFamilyVM(
                productFamily: item.family,
                imageData: item.images?.first)
        }
    }
}

// MARK: - Data mapping from ProductVariantDTO and [ProductVariantDTO]

extension Array where Element == ProductVariantDTO {
    var asProductVariants: [ProductVariant] {
        self.map { item in
            item.asProductVariant
        }
    }
}

extension Array where Element == ProductVariantDTO {
    var asProductVariantsVM: [ProductVariantVM] {
        self.map { item in
            item.asProductVariantVM
        }
    }
}

extension ProductVariantDTO {
    var asProductVariant: ProductVariant {
        ProductVariant(
            frameColor: self.frameColor,
            lenseColor: self.lenseColor,
            price: self.price,
            imgId: self.imgId)
    }
}

extension ProductVariantDTO {
    var asProductVariantVM: ProductVariantVM {
        ProductVariantVM(
            priceLabel: "$ " + String(format: "%.2f", Double(self.price) / 100.0),
            frameColor: self.frameColor,
            lenseColor: self.lenseColor,
            priceInCents: self.price,
            color: self.color,
            imageId: self.imgId)
    }
}

// MARK: - Data mapping from Product, ProductVariant and [ProductVariant]

extension Product {
    var asProductDTO: ProductDTO {
        ProductDTO(
            id: self.id,
            name: self.name,
            type: self.type,
            family: self.family,
            gender: self.gender,
            size: self.size,
            geofit: self.geofit,
            variations: self.variations.asProductVariantsDTO,
            details: self.details,
            images: nil)
    }
}

extension Array where Element == ProductVariant {
    var asProductVariantsDTO: [ProductVariantDTO] {
        self.map { item in
            item.asProductVariantDTO
        }
    }
}

extension ProductVariant {
    var asProductVariantDTO: ProductVariantDTO {
        ProductVariantDTO(
            frameColor: self.frameColor,
            lenseColor: self.lenseColor,
            price: self.price,
            imgId: self.imgId)
    }
}
