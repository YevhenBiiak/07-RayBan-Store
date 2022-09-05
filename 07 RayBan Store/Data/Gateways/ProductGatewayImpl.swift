//
//  ProductGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import Foundation

protocol ApiProduct {
    func fetchProducts(completionHandler: @escaping (Result<[Product]>) -> Void)
}

protocol ApiClient {
    
}

protocol ImageCacher {
    
}

class ProductGatewayImpl: ProductGateway {
    
    private let apiClient: ApiClient
    private let apiProduct: ApiProduct
    private let imageCacher: ImageCacher
    
    init(apiProduct: ApiProduct, apiClient: ApiClient, imageCacher: ImageCacher) {
        self.apiProduct = apiProduct
        self.apiClient = apiClient
        self.imageCacher = imageCacher
    }
    
    func fetchProduct(byId productId: String, completionHandler: @escaping (Result<ProductDTO>) -> Void) {
        
    }
    
    func fetchProducts(first: Int?, skip: Int?, completionHandler: @escaping (Result<[ProductDTO]>) -> Void) {
        
    }
    
    func fetchProducts(byCategoryName category: String, completionHandler: @escaping (Result<[ProductDTO]>) -> Void) {
        
    }
    
    func fetchProducts(byIdentifiers identifiers: [String], completionHandler: @escaping (Result<[ProductDTO]>) -> Void) {
        
    }
    
    func fetchImageData(byProductId productId: String, completionHandler: @escaping (Result<ProductImageDataDTO>) -> Void) {
        
    }
}
