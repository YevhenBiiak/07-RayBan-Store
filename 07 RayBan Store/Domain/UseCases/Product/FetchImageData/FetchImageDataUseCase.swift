//
//  FetchImageDataUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

class FetchImageDataUseCase: UseCase<ImageDataRequest, ImageDataResponse, Never> {
    
    private let productGateway: ProductGateway
    
    init(productGateway: ProductGateway) {
        self.productGateway = productGateway
    }
    
    override func execute(_ request: ImageDataRequest, completionHandler: @escaping (Result<ImageDataResponse>) -> Void) {
        let productId = request.productId
        
        productGateway.fetchImageData(byProductId: productId) { result in
            switch result {
            case .success(let imageDataDTO):
                let fetchImageDataResponse = ImageDataResponse(productImageData: imageDataDTO)
                
                completionHandler(.success(fetchImageDataResponse))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
