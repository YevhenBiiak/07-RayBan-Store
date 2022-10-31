//
//  GetProductsUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

protocol GetProductsUseCase {
    func execute(_ request: GetProductsRequest) async throws -> GetProductsResponse
    func execute(_ request: GetProductsRequest, completionHandler: @escaping (Result<GetProductsResponse>) -> Void)
}

class GetProductsUseCaseImpl: GetProductsUseCase {
    
    enum GetProductsError: Error, LocalizedError {
        case irrelevantResult
        
        var errorDescription: String? {
            switch self {
            case .irrelevantResult:
                return "irrelevant result"
            }
        }
    }
    
    private struct RequestParams: Equatable {
        var id: String?
        var color: String?
        var type: ProductType?
        var family: ProductFamily?
        var category: ProductCategory?
        var first: Int?
        var skip: Int?
        var typeForFamiliesRepresentation: ProductType?
    }
    
    private let productGateway: ProductGateway
    private let operationQueue = OperationQueue()
    private var currentRequest: RequestParams!
    
    init(productGateway: ProductGateway) {
        self.productGateway = productGateway
    }
    
    func execute(_ request: GetProductsRequest) async throws -> GetProductsResponse {
        var result: FetchProductsResult
        let request = self.parseRequestParams(from: request)
        self.currentRequest = request
        
        if let id = request.id {
            result = try await productGateway.fetchProduct(byId: id, productColor: request.color)
            return try handleFetchProductsResult(result)
        }
        
        if let type = request.type, let first = request.first, let skip = request.skip {
            result = try await productGateway.fetchProducts(type: type, category: request.category, family: request.family, first: first, skip: skip)
            return try handleFetchProductsResult(result)
        }
        
        if let type = request.typeForFamiliesRepresentation {
            result = try await productGateway.fetchProducts(asRepresentationOfProductFamiliesOfType: type)
            return try handleFetchProductsResult(result)
        }
        
        func handleFetchProductsResult(_ result: FetchProductsResult) throws -> GetProductsResponse {
            guard request == currentRequest else {
                print("throw")
                throw GetProductsError.irrelevantResult
            }
            return GetProductsResponse(products: result.products, totalNumberOfProducts: result.totalCount)
        }
        
        fatalError("add queries to GetProductsRequest")
    }
    
    func execute(_ request: GetProductsRequest, completionHandler: @escaping (Result<GetProductsResponse>) -> Void) {
        let request = self.parseRequestParams(from: request)
        self.currentRequest = request
        Task {
            if let id = request.id {
                let result = try await self.productGateway.fetchProduct(byId: id, productColor: request.color)
                guard request == self.currentRequest else { return }
                self.handleFetchProductsResult(.success(result), completionHandler: completionHandler)
            }
            
            if let type = request.type, let first = request.first, let skip = request.skip {
                let result = try await self.productGateway.fetchProducts(type: type, category: request.category, family: request.family, first: first, skip: skip)
                guard request == self.currentRequest else { return }
                self.handleFetchProductsResult(.success(result), completionHandler: completionHandler)
            }
            
            if let type = request.typeForFamiliesRepresentation {
                let result = try await self.productGateway.fetchProducts(asRepresentationOfProductFamiliesOfType: type)
                guard request == self.currentRequest else { return }
                self.handleFetchProductsResult(.success(result), completionHandler: completionHandler)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func handleFetchProductsResult(_ result: Result<FetchProductsResult>, completionHandler: (Result<GetProductsResponse>) -> Void) {
        switch result {
        case .success(let (productsDTO, totalCount)):
            
            completionHandler(.success(GetProductsResponse(products: productsDTO, totalNumberOfProducts: totalCount)))
            
        case .failure(let error):
            
            completionHandler(.failure(error))
        }
    }
    
    private func parseRequestParams(from request: GetProductsRequest) -> RequestParams {
        var requestParams = RequestParams()
        
        request.queries.forEach { query in
            switch query {
            case let .id(queryId):
                requestParams.id       = queryId
            case let .color(queryColor):
                requestParams.color    = queryColor
            case let .type(queryType):
                requestParams.type     = queryType
            case let .family(queryFamily):
                requestParams.family   = queryFamily
            case let .category(queryCategory):
                requestParams.category = queryCategory
            case let .limit(queryFirst, querySkip):
                requestParams.first    = queryFirst
                requestParams.skip     = querySkip
            case let .representationOfProductFamilies(queryType):
                requestParams.typeForFamiliesRepresentation = queryType }
        }
        return requestParams
    }
}
