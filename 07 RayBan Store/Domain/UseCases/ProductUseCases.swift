//
//  ProductUseCases.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

protocol ProductUseCases {
    func retrieveProducts(completionHandler: @escaping (Result<[Product]>) -> Void)
}

class ProductUseCasesImpl: ProductUseCases {
    private let productGateway: ProductGateway
    
    init(productGateway: ProductGateway) {
        self.productGateway = productGateway
    }
    
    func retrieveProducts(completionHandler: @escaping (Result<[Product]>) -> Void) {
        productGateway.retrieveProducts { result in
            completionHandler(result)
        }
    }
}
