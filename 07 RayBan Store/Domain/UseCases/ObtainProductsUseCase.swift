//
//  ObtainProductsUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

protocol ObtainProductsUseCase {
    func obtainProducts(completionHandler: @escaping  (Result<[Product]>) -> Void)
}

class ObtainProductsUseCaseImpl: ObtainProductsUseCase {
    private let productsGateway: ProductsGateway
    
    init(productsGateway: ProductsGateway) {
        self.productsGateway = productsGateway
    }
    
    func obtainProducts(completionHandler: @escaping (Result<[Product]>) -> Void) {
        productsGateway.fetchProducts { result in
            completionHandler(result)
        }
    }
}
