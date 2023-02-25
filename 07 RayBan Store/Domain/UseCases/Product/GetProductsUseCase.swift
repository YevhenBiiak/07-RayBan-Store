//
//  GetProductsUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

protocol GetProductsUseCase {
    func execute(_ request: ProductWithIDRequest) async throws -> Product
    func execute(_ request: ProductWithModelIDRequest) async throws -> Product
    func execute(_ request: ProductRequest) async throws -> Product
    func execute(_ request: ProductsCountRequest) async throws -> Int
    func execute(_ request: ProductStylesRequest) async throws -> [Product]
}

class GetProductsUseCaseImpl {
    
    private let productGateway: ProductGateway
    
    init(productGateway: ProductGateway) {
        self.productGateway = productGateway
    }
}

extension GetProductsUseCaseImpl: GetProductsUseCase {
    
     // get the product for cart or order
     func execute(_ request: ProductWithIDRequest) async throws -> Product {
         try await productGateway.fetchProduct(productID: request.productID, includeImages: true)
         // here can be some domain logic
     }
    
    // get the product for product details
    func execute(_ request: ProductWithModelIDRequest) async throws -> Product {
        try await productGateway.fetchProduct(modelID: request.modelID, includeImages: true)
        // here can be some domain logic
    }
    
    // get the product for products screen
    func execute(_ request: ProductRequest) async throws -> Product {
        try await productGateway.fetchProduct(category: request.category, gender: request.gender, style: request.style, index: request.index)
        // here can be some domain logic
    }
    
    // get the products count for products screen
    func execute(_ request: ProductsCountRequest) async throws -> Int {
        try await productGateway.productsCount(category: request.category, gender: request.gender, style: request.style)
        // here can be some domain logic
    }
    
    // get the products for categories screen
    func execute(_ request: ProductStylesRequest) async throws -> [Product] {
        try await productGateway.fetchProductStyles(category: request.category, includeImages: request.includeImages)
        // here can be some domain logic
    }
}
