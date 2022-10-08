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
        var id: String?
        var color: String?
        var type: ProductType?
        var family: ProductFamily?
        var category: ProductCategory?
        var first: Int?
        var skip: Int?
        var typeForFamiliesRepresentation: ProductType?
        
        request.queries.forEach { query in
            switch query {
            case let .id(queryId): id = queryId
            case let .color(queryColor): color = queryColor
            case let .type(queryType): type = queryType
            case let .family(queryFamily): family = queryFamily
            case let .category(queryCategory): category = queryCategory
            case let .limit(queryFirst, querySkip): first = queryFirst; skip = querySkip
            case let .representationOfProductFamilies(queryType): typeForFamiliesRepresentation = queryType }
        }
        
        if let id {
            productGateway.fetchProduct(byId: id, productColor: color) { [weak self] result in
                self?.handleFetchProductsResult(result, completionHandler: completionHandler)
            }
        }
        
        if let type, let first, let skip {
            productGateway.fetchProducts(type: type, category: category, family: family, first: first, skip: skip) { [weak self] result in
                self?.handleFetchProductsResult(result, completionHandler: completionHandler)
            }
        }
        
        if let type = typeForFamiliesRepresentation {
            productGateway.fetchProducts(asRepresentationOfProductFamiliesOfType: type) { [weak self] result in
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
