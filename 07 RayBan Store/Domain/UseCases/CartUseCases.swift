//
//  CartUseCases.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import Foundation

protocol CartUseCases {
    var isCartEmpty: Bool { get }
    func add(_ product: Product, completionHandler: @escaping (Result<[CartItem]>) -> Void)
    func delete(productId: String, completionHandler: @escaping (Result<[CartItem]>) -> Void)
    func update(id: String, amount: Int, completionHandler: @escaping (Result<[CartItem]>) -> Void)
    func getItems(completionHandler: @escaping (Result<[CartItem]>) -> Void)
    func createOrder(completionHandler: @escaping (Result<[OrderItem]>) -> Void)
}

class CartUseCasesImpl: CartUseCases {
    
    private let cartGateway: CartGateway
    
    init(cartGateway: CartGateway) {
        self.cartGateway = cartGateway
    }
    
    var isCartEmpty: Bool {
        cartGateway.isCartEmpty
    }
    
    func add(_ product: Product, completionHandler: @escaping (Result<[CartItem]>) -> Void) {
        cartGateway.add(product) { result in
            completionHandler(result)
        }
    }
    
    func delete(productId: String, completionHandler: @escaping (Result<[CartItem]>) -> Void) {
        cartGateway.delete(productId: productId) { result in
            completionHandler(result)
        }
    }
    
    func update(id: String, amount: Int, completionHandler: @escaping (Result<[CartItem]>) -> Void) {
        cartGateway.update(id: id, amount: amount) { result in
            completionHandler(result)
        }
    }
    
    func getItems(completionHandler: @escaping (Result<[CartItem]>) -> Void) {
        cartGateway.getItems { result in
            completionHandler(result)
        }
    }
    
    func createOrder(completionHandler: @escaping (Result<[OrderItem]>) -> Void) {
        cartGateway.createOrder { result in
            completionHandler(result)
        }
    }
}
