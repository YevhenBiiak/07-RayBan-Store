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
//        if let index = items.firstIndex(where: { $0.product.variations.first?.productID == product.variations.first?.productID }) {
//            items[index].amount += amount
//        } else {
//            items.append(item)
//        }
    }
    
    mutating func update(productID: Int, amount: Int) {
        for (i, item) in items.enumerated() where item.product.variations.first!.productID == productID {
            items[i].amount = amount
        }
    }
    
    mutating func delete(productID: Int) {
        items.removeAll { $0.product.variations.first?.productID == productID }
    }
    
    func contains(_ productID: ProductID) -> Bool {
        items.contains {
            $0.product.variations.contains {
                $0.productID == productID
            }
        }
    }
    
    func orderSummary(shippingMethod: ShippingMethod) -> OrderSummary {
        OrderSummary(
            subtotal: totalPrice(),
            shipping: shippingMethod.price,
            total: totalPrice() + shippingMethod.price
        )
    }
    
    func createOrder(deliveryInfo: DeliveryInfo, shippingMethod: ShippingMethod) -> Order {
        Order(
            items: items,
            deliveryInfo: deliveryInfo,
            shippingMethod: shippingMethod,
            summary: orderSummary(shippingMethod: shippingMethod)
        )
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
