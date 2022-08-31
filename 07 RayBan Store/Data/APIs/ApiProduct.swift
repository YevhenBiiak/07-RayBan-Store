//
//  ApiProduct.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

class ApiProductImpl: ApiProduct {
    private let products = [
        Product(id: "1", title: "One", category: "One", details: "details", price: 9400),
        Product(id: "2", title: "Two", category: "Two", details: "details", price: 3300),
        Product(id: "3", title: "Three", category: "One", details: "details", price: 12000),
        Product(id: "4", title: "Four", category: "One", details: "details", price: 9500),
        Product(id: "5", title: "Five", category: "Two", details: "details", price: 8500)
    ]
    
    func fetchProducts(completionHandler: @escaping (Result<[Product]>) -> Void) {
        completionHandler(.success(products))
    }
}
