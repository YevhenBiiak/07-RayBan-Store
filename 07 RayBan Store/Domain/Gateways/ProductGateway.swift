//
//  ProductGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

protocol ProductGateway {
    func fetchProduct(byIdentifier productId: Int, completionHandler: @escaping (Result<ProductDTO>) -> Void)
    func fetchProducts(first: Int, skip: Int, completionHandler: @escaping (Result<[ProductDTO]>) -> Void)
    func fetchProducts(byCategoryName category: String, first: Int, skip: Int, completionHandler: @escaping (Result<[ProductDTO]>) -> Void)
    func fetchProducts(byIdentifiers identifiers: [Int], first: Int, skip: Int, completionHandler: @escaping (Result<[ProductDTO]>) -> Void)
}
