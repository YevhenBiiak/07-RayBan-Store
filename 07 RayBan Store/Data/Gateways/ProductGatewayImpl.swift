//
//  ProductGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import Foundation
import FirebaseDatabase

protocol ApiProduct {
    
}

protocol ApiClient {
    
}

class ProductGatewayImpl: ProductGateway {
    
    func fetchProduct(byId productId: String, completionHandler: @escaping (Result<ProductDTO>) -> Void) {
        Database.database().reference()
    }
    
    func fetchProducts(first: Int?, skip: Int?, completionHandler: @escaping (Result<[ProductDTO]>) -> Void) {
        
    }
    
    func fetchProducts(byCategoryName category: String, completionHandler: @escaping (Result<[ProductDTO]>) -> Void) {
        
    }
    
    func fetchProducts(byIdentifiers identifiers: [String], completionHandler: @escaping (Result<[ProductDTO]>) -> Void) {
        
    }
    
    func fetchImages(byProductId productId: String, completionHandler: @escaping (Result<ProductImagesDTO>) -> Void) {
        
    }
}
