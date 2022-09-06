//
//  FetchProductImagesUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

protocol FetchProductImagesUseCase {
    func execute(_ request: FetchProductImagesRequest, completionHandler: @escaping (Result<FetchProductImagesResponse>) -> Void)
}

class FetchImagesUseCaseImpl: FetchProductImagesUseCase {
    
    private let productGateway: ProductGateway
    
    init(productGateway: ProductGateway) {
        self.productGateway = productGateway
    }
    
    func execute(_ request: FetchProductImagesRequest, completionHandler: @escaping (Result<FetchProductImagesResponse>) -> Void) {
        let productId = request.productId
        
        productGateway.fetchImages(byProductId: productId) { result in
            switch result {
            case .success(let productImagesDTO):
                let fetchImagesResponse = FetchProductImagesResponse(productImages: productImagesDTO)
                
                completionHandler(.success(fetchImagesResponse))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
