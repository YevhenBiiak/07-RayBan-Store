//
//  CartGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

protocol ApiCart {
    func sendOrder()
}

protocol CartLocalStorage {
    var isCartEmpty: Bool { get }
}

class CartGatewayImpl: CartGateway {
    
    private let apiCart: ApiCart
    private let cartLocalStorage: CartLocalStorage
    
    init(apiCart: ApiCart, cartLocalStorage: CartLocalStorage) {
        self.apiCart = apiCart
        self.cartLocalStorage = cartLocalStorage
    }

    var isCartEmpty: Bool {
        cartLocalStorage.isCartEmpty
    }
    
    func add(_ product: Product, completionHandler: @escaping (Result<[CartItem]>) -> Void) {
        
    }
    
    func delete(productId: String, completionHandler: @escaping (Result<[CartItem]>) -> Void) {
        
    }
    
    func update(id: String, amount: Int, completionHandler: @escaping (Result<[CartItem]>) -> Void) {
        
    }
    
    func getItems(completionHandler: @escaping (Result<[CartItem]>) -> Void) {
        
    }
    
    func createOrder(completionHandler: @escaping (Result<[OrderItem]>) -> Void) {
        apiCart.sendOrder()
    }
}
