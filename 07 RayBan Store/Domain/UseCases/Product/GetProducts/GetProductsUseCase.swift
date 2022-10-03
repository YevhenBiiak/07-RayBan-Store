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
        case let .identifier(id):
            productGateway.fetchProduct(byIdentifier: id) { [weak self] result in
                self?.handleFetchProductsResult(result, completionHandler: completionHandler)
            }
        case let .identifiers(ids, first, skip):
            productGateway.fetchProducts(byIdentifiers: ids, first: first, skip: skip) { [weak self] result in
                self?.handleFetchProductsResult(result, completionHandler: completionHandler)
            }
        case let .products(type, category, family, first, skip):
            productGateway.fetchProducts(type: type, category: category, family: family, first: first, skip: skip) { [weak self] result in
                self?.handleFetchProductsResult(result, completionHandler: completionHandler)
            }
        case let .productFamiliesDescription(type):
            productGateway.fetchProducts(asDescriptionOfProductFamiliesOfType: type) { [weak self] result in
                self?.handleFetchProductsResult(result, completionHandler: completionHandler)
            }
        }
    }
    
    private func handleFetchProductsResult(_ result: Result<FetchProductsResult>, completionHandler: (Result<GetProductsResponse>) -> Void) {
        switch result {
        case .success(let (productsDTO, totalCount)):
            
            completionHandler(.success(GetProductsResponse(products: productsDTO, totalNumberOfProducts: totalCount)))
            
        case .failure(let error):
            
            completionHandler(.failure(error))
        }
    }
}
