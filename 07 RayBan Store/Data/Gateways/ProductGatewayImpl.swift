//
//  ProductGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import UIKit

protocol ImagesAPI {
    func loadImages(_ types: [ImageType], imageId: Int, bgColor: UIColor) async throws -> [Data]
}

protocol ProductsAPI {
    func fetchProducts() async throws -> [Product]
}

class ProductGatewayImpl {
    
    private let productsAPI: ProductsAPI
    private let imagesApi: ImagesAPI
    
    init(productsAPI: ProductsAPI, imagesApi: ImagesAPI) {
        self.productsAPI = productsAPI
        self.imagesApi = imagesApi
    }
}

extension ProductGatewayImpl: ProductGateway {
    
    func fetchProduct(modelID: String, includeImages: Bool) async throws -> Product {
        let product = try await productsAPI.fetchProducts().first { $0.modelID == modelID }
        guard var product else { throw AppError.invalidProductModelID }
        guard includeImages else { return product }
        
        // load images for all product variants
        try await loadImages(for: &product, imgTypes: [.main, .front2, .main2, .perspective, .left, .back], bgColor: .appLightGray)
        return product
    }
    
    func fetchProduct(productID: Int, includeImages: Bool) async throws -> Product {
        let product = try await productsAPI.fetchProducts().first { $0.variations.contains { $0.productID == productID }}
        let variation = product?.variations.first { $0.productID == productID }
        guard var product, let variation else { throw AppError.invalidProductIdentifier }
        product.variations = [variation]
        
        guard includeImages else { return product }
        
        // load images for product variant with productID
        try await loadImages(for: &product, withID: productID, imgTypes: [.main], bgColor: .appLightGray)
        return product
    }
    
    // Product by Category, Style, Gender
    func fetchProduct(category: Product.Category, gender: Product.Gender?, style: Product.Style?, index: Int) async throws -> Product {
        let products = try await productsAPI.fetchProducts()
            .filter(category: category, gender: gender, style: style)
        
        guard index < products.count else { throw AppError.invalidProductIndex }
        var product = products[index]
        
        // load images for first product variant
        try await loadImages(for: &product, withID: product.variations.first?.productID, imgTypes: [.main], bgColor: .appLightGray)
        return product
    }
    
    // Products by Category, Style, Gender with indices
    func fetchProducts(category: Product.Category, gender: Product.Gender?, style: Product.Style?, indices: [Int]) async throws -> [Product] {
        var products = try await productsAPI.fetchProducts()
            .filter(category: category, gender: gender, style: style)
        
        guard indices.count <= products.count else { throw AppError.invalidProductIndex }
        products = Array(products.prefix(indices.last ?? 0))
        
        // load images for first product variant
        try await loadImages(for: &products, imgTypes: [.main], bgColor: .appLightGray)
        return products
    }
    
    // Products count by Category, Style, Gender
    func productsCount(category: Product.Category, gender: Product.Gender?, style: Product.Style?) async throws -> Int {
        try await productsAPI.fetchProducts()
            .filter(category: category, gender: gender, style: style)
            .count
    }
    
    // Representation Of Product Styles Of Category
    func fetchProductStyles(category: Product.Category, includeImages: Bool) async throws -> [Product] {
        var products = try await productsAPI.fetchProducts()
            .filter(category: category)
            .parseProductStyles()
        
        guard includeImages else { return products }
        try await loadImages(for: &products, imgTypes: [.main], bgColor: .appWhite)
        return products
    }
}

// MARK: - Private extensions

private extension ProductGatewayImpl {
    
    func loadImages(for product: inout Product, withID productID: Int? = nil, imgTypes: [ImageType], bgColor: UIColor) async throws {
        if let productID {
            guard let index = product.variations.firstIndex(where: { $0.productID == productID }) else { return }
            product.variations[index].imageData = try await imagesApi.loadImages(imgTypes, imageId: productID, bgColor: bgColor)
            
        } else {
            product.variations = try await product.variations.concurrentMap { [weak self] in var variation = $0
                let imageData = try await self?.imagesApi.loadImages(imgTypes, imageId: variation.productID, bgColor: bgColor)
                variation.imageData = imageData
                return variation
            }
        }
    }
    
    func loadImages(for products: inout [Product], imgTypes: [ImageType], bgColor: UIColor) async throws {
        products = try await products.concurrentMap { [weak self] in var product = $0
            guard let variation = product.variations.first else { return product }
            
            let imageData = try await self?.imagesApi.loadImages(imgTypes, imageId: variation.productID, bgColor: bgColor)
            product.variations[0].imageData = imageData
            
            return product
        }
    }
}

private extension Array where Element == Product {
    
    func filter(category: Product.Category, gender: Product.Gender? = nil, style: Product.Style? = nil) -> Self {
        // filter products with product category
        var products = filter { $0.category == category }
        
        // filter products with gender
        switch gender {
        case .male:   products = products.filter { $0.gender == .male || $0.gender == .unisex }
        case .female: products = products.filter { $0.gender == .female || $0.gender == .unisex }
        case .child:  products = products.filter { $0.gender == .child }
        case .unisex: products = products.filter { $0.gender == .unisex }
        case .none: break }
        
        // filter products with product style
        if let style { products = products.filter { $0.style == style } }
        
        return products
    }
    
    func parseProductStyles() -> Self {
        return reduce(into: []) { result, product in
            guard !result.contains(where: { $0.style == product.style }) else { return }
            result.append(product)
        }
    }
}
