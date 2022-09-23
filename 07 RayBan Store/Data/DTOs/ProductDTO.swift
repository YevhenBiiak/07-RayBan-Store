//
//  ProductDTO.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation
import UIKit

struct ProductDTO: Codable {
    let id: Int
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
    
    var asProductViewModel: ProductViewModel {
        ProductViewModel(id: self.id,
                         title: self.title,
                         category: self.category,
                         details: self.details,
                         price: self.price,
                         images: [self.images?.main,
                                  self.images?.main2,
                                  self.images?.perspective,
                                  self.images?.front,
                                  self.images?.frontClosed,
                                  self.images?.back,
                                  self.images?.left
                                 ].compactMap { $0 })
    }
}

extension Array where Element == ProductDTO {
    var asProductsViewModel: [ProductViewModel] {
        self.map { item in
            item.asProductViewModel
        }
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
