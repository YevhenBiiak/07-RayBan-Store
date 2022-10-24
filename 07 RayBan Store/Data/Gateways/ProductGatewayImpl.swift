//
//  ProductGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import UIKit

protocol ProductImagesApi {
    func loadImages(_ types: [ImageType], imageId: Int, bgColor: UIColor,
                    failureCompletion: @escaping (Error) -> Void,
                    successCompletion: @escaping ([Data]) -> Void)
}

protocol RemoteRepository {
    func executeFetchRequest<T: Decodable>(ofType request: FetchRequest, completionHandler: @escaping (Result<T>) -> Void)
    func executeSaveRequest(ofType request: SaveRequest, completionHandler: @escaping (Result<Bool>) -> Void)
}

// swiftlint:disable closure_parameter_position
class ProductGatewayImpl: ProductGateway {
    
    private let operationQueue = OperationQueue()
    private let productImagesApi: ProductImagesApi
    private let remoteRepository: RemoteRepository
    
    init(productImagesApi: ProductImagesApi, remoteRepository: RemoteRepository) {
        self.remoteRepository = remoteRepository
        self.productImagesApi = productImagesApi
    }
    
    // One product by id
    func fetchProduct(
        byId productId: String, productColor: String?,
        completionHandler: @escaping (Result<FetchProductsResult>) -> Void
    ) {
        remoteRepository.executeFetchRequest(ofType: .productById(id: productId)) {
            [weak self] (result: Result<ProductDTO>) in
            
            switch result {
            case .success(var product):
                
                let result = ([product], 1)
                completionHandler(.success(result))
                
                let imageId: Int?
                switch productColor {
                case .none:            imageId = product.variations.first?.imgId
                case .some(let color): imageId = product.variations.first(where: { $0.color == color })?.imgId }
                guard let imageId else { break }
                
                self?.productImagesApi.loadImages([.main, .perspective, .back, .front, .left], imageId: imageId, bgColor: .appLightGray,
                failureCompletion: { error in
                    completionHandler(.failure(error))
                }, successCompletion: { images in
                    product.images = images
                    let result = ([product], 1)
                    completionHandler(.success(result))
                })
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // Products by type, category, family
    func fetchProducts(
        type: ProductType, category: ProductCategory?, family: ProductFamily?, first: Int, skip: Int,
        completionHandler: @escaping (Result<FetchProductsResult>) -> Void
    ) {
        remoteRepository.executeFetchRequest(ofType: .productsByType(name: type.rawValue)) {
            [weak self] (result: Result<[ProductDTO]>) in
            
            switch result {
            case .success(var products):
                
                // filter products with product family
                if let family { products = products.filter { $0.family.lowercased() == family.rawValue.lowercased() }}
                
                // filter products with category
                switch category {
                case .men:   products = products.filter { $0.gender.lowercased() == "male" || $0.gender.lowercased() == "unisex" }
                case .women: products = products.filter { $0.gender.lowercased() == "female" || $0.gender.lowercased() == "unisex" }
                case .kids:  products = products.filter { $0.gender.lowercased() == "child" }
                case .none: break }
                
                let totalCount = products.count
                //filter products with required quantity
                products = Array(products.dropFirst(skip).prefix(first))
                
                for (i, product) in products.enumerated() {
                    let semaphor = DispatchSemaphore(value: 0)
                    let operation = BlockOperation {
                        guard let imageId = product.variations.first?.imgId else { return print("imageId is nil") }
                        //print(Thread.current)
                        print(i)
                        self?.productImagesApi.loadImages([.main], imageId: imageId, bgColor: .appLightGray, failureCompletion: { error in
                            semaphor.signal()
                            return completionHandler(.failure(error))
                        }, successCompletion: { data in
                            semaphor.signal()
                            products[i].images = data
                        })
                        _ = semaphor.wait(timeout: .distantFuture)
                    }
                    self?.operationQueue.addOperation(operation)
                }
                
                self?.operationQueue.waitUntilAllOperationsAreFinished()
                print("exit")
                let result = (products, totalCount)
                completionHandler(.success(result))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // Description Of Product Families Of Type
    func fetchProducts(
        asRepresentationOfProductFamiliesOfType type: ProductType,
        completionHandler: @escaping (Result<FetchProductsResult>) -> Void
    ) {
        remoteRepository.executeFetchRequest(ofType: .productsByType(name: type.rawValue)) {
            [weak self] (result: (Result<[ProductDTO]>)) in
            
            switch result {
            case .success(var products):
                
                products = products.reduce(into: []) { result, product in
                    if !result.contains(where: { $0.family == product.family }) {
                        result.append(product)
                    }
                }
                
                let result = (products, products.count)
                completionHandler(.success(result))
                
                for (i, product) in products.enumerated() {
                    guard let imageId = product.variations.first?.imgId else { continue }
                    
                    self?.productImagesApi.loadImages([.main], imageId: imageId, bgColor: .appWhite,
                    failureCompletion: { error in
                        completionHandler(.failure(error))
                    }, successCompletion: { images in
                        products[i].images = images
                        let result = (products, products.count)
                        completionHandler(.success(result))
                    })
                }
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
