//
//  ProductGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

protocol ProductGateway {
    func fetchProduct(byIdentifier productId: String, completionHandler: @escaping (Result<ProductDTO>) -> Void)
    func fetchProducts(first: Int, skip: Int, completionHandler: @escaping (Result<[ProductDTO]>) -> Void)
    func fetchProducts(byCategoryName category: String, first: Int, skip: Int, completionHandler: @escaping (Result<[ProductDTO]>) -> Void)
    func fetchProducts(byIdentifiers identifiers: [String], first: Int, skip: Int, completionHandler: @escaping (Result<[ProductDTO]>) -> Void)
}
// func fetchImages(byProductId productId: String, completionHandler: @escaping (Result<ProductImagesDTO>) -> Void)
