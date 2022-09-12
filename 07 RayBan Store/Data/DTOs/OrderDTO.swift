//
//  OrderDTO.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.09.2022.
//

import Foundation

struct OrderDTO: Codable {
    let id: String?      // nil when call createOrder
    let status: String?  // nil when call createOrder
    let customerId: String
    let items: [OrderItemDTO]
    let shippingMethods: String
    let shippindAddress: String
    let price: Cent
}

struct OrderItemDTO: Codable {
    let product: ProductDTO
    let amount: Int
}

// Data mapping
extension Array where Element == OrderItem {
    var asOrderItemsDTO: [OrderItemDTO] {
        self.map { item in
            OrderItemDTO(product: item.product.asProductDTO, amount: item.amount)
        }
    }
}

extension OrderDTO: DictionaryConvertible {
    var asDictionary: [String: Any] {
        ["\(Date.now.timeIntervalSince1970)": self]
    }
}

extension Order {
    var asOrderDTO: OrderDTO {
        OrderDTO(id: nil,
                 status: nil,
                 customerId: self.customerId,
                 items: self.items.asOrderItemsDTO,
                 shippingMethods: self.shippingMethods,
                 shippindAddress: self.shippindAddress,
                 price: self.price)
    }
}
