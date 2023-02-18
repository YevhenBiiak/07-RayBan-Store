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
    
    mutating func update(productID: Int, amount: Int) {
        for (i, item) in items.enumerated() where item.product.variations.first!.productID == productID {
            items[i].amount = amount
        }
    }
    
    mutating func delete(productID: Int) {
        items = items.filter { $0.product.variations.first!.productID != productID }
    }

    func contains(_ product: Product) -> Bool {
        items.contains {
            $0.product.variations.contains {
                $0.productID == product.variations.first?.productID
            }
        }
    }
    
    func createOrder(shippindAddress: String, shippingMethods: String) -> Order {
        Order(items: items,
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
        product.variations.first!.price * amount
    }
}
