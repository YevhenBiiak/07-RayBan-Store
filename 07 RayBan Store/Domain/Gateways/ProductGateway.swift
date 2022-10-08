//
//  ProductGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

typealias FetchProductsResult = (products: [ProductDTO], totalCount: Int)

protocol ProductGateway {
    func fetchProduct(byId productId: String, productColor: String?,
                      completionHandler: @escaping (Result<FetchProductsResult>) -> Void)
    
    func fetchProducts(type: ProductType, category: ProductCategory?, family: ProductFamily?, first: Int, skip: Int,
                       completionHandler: @escaping (Result<FetchProductsResult>) -> Void)
    
    func fetchProducts(asRepresentationOfProductFamiliesOfType type: ProductType,
                       completionHandler: @escaping (Result<FetchProductsResult>) -> Void)
}
