//
//  ProductDTO.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation
import UIKit

struct ProductDTO: Codable {
    let id: String
    let title: String
    let category: String
    let details: String
    let price: Int
    var images: ProductImages?
}

// Data mapping
extension ProductDTO {
    var asProduct: Product {
        Product(id: self.id,
                title: self.title,
                category: self.category,
                details: self.details,
                price: self.price)
    }
}

extension Product {
    var asProductDTO: ProductDTO {
        ProductDTO(id: self.id,
                   title: self.title,
                   category: self.category,
                   details: self.details,
                   price: self.price,
                   images: nil)
    }
}
