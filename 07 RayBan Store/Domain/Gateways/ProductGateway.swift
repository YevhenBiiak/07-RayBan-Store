//
//  ProductGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

enum ImageOption {
    case noImages
    case image(res: ImageResolution)
}

protocol ProductGateway {
    /// Returns the product with the given model id, which contains all variants and images.
    func fetchProduct(modelID: String, options: ImageOption) async throws -> Product
    /// Returns a product that contains a single variation with the given product ID.
    func fetchProduct(productID: Int, options: ImageOption) async throws -> Product
    func fetchProductStyles(category: Product.Category, options: ImageOption) async throws -> [Product]
    func fetchProduct(category: Product.Category, gender: Product.Gender?, style: Product.Style?, index: Int) async throws -> Product
    func fetchProducts(category: Product.Category, gender: Product.Gender?, style: Product.Style?, range: Range<Int>) async throws -> [Product]
    func productsCount(category: Product.Category, gender: Product.Gender?, style: Product.Style?) async throws -> Int
}
