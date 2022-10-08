//
//  Cart.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import Foundation

struct Cart {
    var items: [CartItem]
    
    var isCartEmpty: Bool {
        items.isEmpty
        //totalPrice() < 50_00
    }
    
    mutating func add(product: Product, amount: Int) {
        let item = CartItem(product: product, amount: amount)
        items.append(item)
    }
    
    mutating func update(productId: String, amount: Int) {
        for (i, item) in items.enumerated() where item.product.id == productId {
            items[i].amount = amount
        }
    }
    
    mutating func delete(productId: String) {
        items = items.filter { $0.product.id != productId }
    }
    
    func createOrder(userId: String, shippindAddress: String, shippingMethods: String) -> Order {
        let orderItems = items.map {
            OrderItem(product: $0.product, amount: $0.amount, price: $0.price())
        }
        
        return Order(userId: userId,
                     items: orderItems,
                     shippingMethods: shippingMethods,
                     shippindAddress: shippindAddress,
                     price: totalPrice())
    }
    
    func totalPrice() -> Cent {
        items.map { $0.price() }.reduce(0, +)
    }
}

// MARK: - Cart Item

struct CartItem {
    let product: Product
    var amount: Int
    
    func price() -> Cent {
        (product.variations.first?.price ?? 0) * amount
    }
}
