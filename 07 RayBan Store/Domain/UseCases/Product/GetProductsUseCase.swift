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
    func execute(_ request: ProductsRequest) async throws -> [Product]
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
        try await productGateway.fetchProduct(productID: request.productID, options: request.options)
        // here can be some domain logic
    }
    
    // get the product for product details
    func execute(_ request: ProductWithModelIDRequest) async throws -> Product {
        try await productGateway.fetchProduct(modelID: request.modelID, options: .image(res: .max))
        // here can be some domain logic
    }
    
    // get the product for products screen
    func execute(_ request: ProductRequest) async throws -> Product {
        try await productGateway.fetchProduct(category: request.category, gender: request.gender, style: request.style, index: request.index)
        // here can be some domain logic
    }
    
    // get product for update visible cells
    func execute(_ request: ProductsRequest) async throws -> [Product] {
        try await productGateway.fetchProducts(category: request.category, gender: request.gender, style: request.style, range: request.range)
        // here can be some domain logic
    }
    
    // get the products count for products screen
    func execute(_ request: ProductsCountRequest) async throws -> Int {
        try await productGateway.productsCount(category: request.category, gender: request.gender, style: request.style)
        // here can be some domain logic
    }
    
    // get the products for categories screen
    func execute(_ request: ProductStylesRequest) async throws -> [Product] {
        try await productGateway.fetchProductStyles(category: request.category, options: request.options)
        // here can be some domain logic
    }
}
