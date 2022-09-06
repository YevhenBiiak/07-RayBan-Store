//
//  FetchProductsUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

protocol FetchProductsUseCase {
    func execute(_ request: FetchProductsRequest, completionHandler: @escaping (Result<FetchProductsResponse>) -> Void)
}

class FetchProductsUseCaseImpl: FetchProductsUseCase {
    
    private let productGateway: ProductGateway
    
    init(productGateway: ProductGateway) {
        self.productGateway = productGateway
    }
    
    func execute(_ request: FetchProductsRequest, completionHandler: @escaping (Result<FetchProductsResponse>) -> Void) {
        if let category = request.category {
            productGateway.fetchProducts(byCategoryName: category) { result in
                switch result {
                case .success(let productsDTO):
                    let fetchProductsResponse = FetchProductsResponse(products: productsDTO)
                    
                    completionHandler(.success(fetchProductsResponse))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        } else if let productId = request.productId {
            productGateway.fetchProduct(byId: productId) { result in
                switch result {
                case .success(let productsDTO):
                    let fetchProductsResponse = FetchProductsResponse(products: [productsDTO])
                    
                    completionHandler(.success(fetchProductsResponse))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
}
