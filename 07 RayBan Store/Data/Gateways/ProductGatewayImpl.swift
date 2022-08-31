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
    
    private let apiProduct: ApiProduct
    private let apiClient: ApiClient
    private let imageCacher: ImageCacher
    
    init(apiProduct: ApiProduct, apiClient: ApiClient, imageCacher: ImageCacher) {
        self.apiProduct = apiProduct
        self.apiClient = apiClient
        self.imageCacher = imageCacher
    }
    
    func retrieveProducts(completionHandler: @escaping (Result<[Product]>) -> Void) {
        apiProduct.fetchProducts { result in
            completionHandler(result)
        }
    }
}
