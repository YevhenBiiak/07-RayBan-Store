//
//  Cart.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import Foundation

struct Cart {
    let userId: String
    var items: [CartItem]
    
    init(userId: String, items: [CartItem] = []) {
        self.userId = userId
        self.items = items
    }
    
    mutating func addItem(product: Product, amount: Int) {
        let item = CartItem(product: product, amount: amount)
        items.append(item)
    }
    
    mutating func update(productId: String, amount: Int) {
        for (i, item) in items.enumerated() where item.product.id == productId {
            items[i].amount = amount
        }
    }
    
    mutating func deleteItem(productId: String) {
        items = items.filter { $0.product.id != productId }
    }
    
    func getItems() -> [CartItem] {
        return items
    }
    
    func createOrder(id: String, shippingMethods: String, shippindAddress: String) -> Order {
        let orderItems = items.map {
            OrderItem(products: $0.product, amount: $0.amount, price: $0.price())
        }
        
        return Order(
            id: id,
            userId: userId,
            items: orderItems,
            shippingMethods: shippingMethods,
            shippindAddress: shippindAddress,
            price: totalPrice())
    }
    
    func totalPrice() -> Cents {
        items.map { $0.price() }.reduce(0, +)
    }
}

// MARK: - Cart Item

struct CartItem {
    let product: Product
    var amount: Int
    
    func price() -> Cents {
        product.price * amount
    }
}
