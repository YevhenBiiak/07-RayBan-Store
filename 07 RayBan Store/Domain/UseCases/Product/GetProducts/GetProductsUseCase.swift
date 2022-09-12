//
//  GetProductsUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

protocol GetProductsUseCase {
    func execute(_ request: GetProductsRequest, completionHandler: @escaping (Result<GetProductsResponse>) -> Void)
}

class GetProductsUseCaseImpl: GetProductsUseCase {
    
    private let productGateway: ProductGateway
    
    init(productGateway: ProductGateway) {
        self.productGateway = productGateway
    }
    
    func execute(_ request: GetProductsRequest, completionHandler: @escaping (Result<GetProductsResponse>) -> Void) {
        switch request.query {
        case .all(first: let first, skip: let skip):
            productGateway.fetchProducts(first: first, skip: skip) { [weak self] result in
                self?.handleFetchProductsResult(result, completionHandler: completionHandler)
            }
        case .identifier(id: let id):
            productGateway.fetchProduct(byIdentifier: id) { [weak self] result in
                self?.handleFetchProductsResult(result, completionHandler: completionHandler)
            }
        case .category(name: let name, first: let first, skip: let skip):
            productGateway.fetchProducts(byCategoryName: name, first: first, skip: skip) { [weak self] result in
                self?.handleFetchProductsResult(result, completionHandler: completionHandler)
            }
        case .identifiers(ids: let ids, first: let first, skip: let skip):
            productGateway.fetchProducts(byIdentifiers: ids, first: first, skip: skip) { [weak self] result in
                self?.handleFetchProductsResult(result, completionHandler: completionHandler)
            }
        }
    }
    
    private func handleFetchProductsResult<T>(_ result: Result<T>, completionHandler: (Result<GetProductsResponse>) -> Void) {
        switch result {
        case .success(let productsDTO):
            if let products = productsDTO as? ProductDTO {
                
                completionHandler(.success(GetProductsResponse(products: [products])))
                
            } else if let products = productsDTO as? [ProductDTO] {
                
                completionHandler(.success(GetProductsResponse(products: products)))
            }
        case .failure(let error):
            completionHandler(.failure(error))
        }
    }
}
