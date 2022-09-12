//
//  CartItemDTO.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.09.2022.
//

import Foundation

struct CartItemDTO: Codable {
    let product: ProductDTO
    let amount: Int
}

// Data mapping
extension Array: DictionaryConvertible where Element == CartItemDTO {
    var asCartItems: [CartItem] {
        self.map { item in
            CartItem(product: item.product.asProduct, amount: item.amount)
        }
    }
    
    var asDictionary: [String: Any] {
        ["cart": self]
    }
}

extension Array where Element == CartItem {
    var asCartItemsDTO: [CartItemDTO] {
        self.map { item in
            CartItemDTO(product: item.product.asProductDTO, amount: item.amount)
        }
    }
}
