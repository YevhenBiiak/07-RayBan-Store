//
//  ProductGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import UIKit

protocol ProductImagesApi {
    func loadImages(_ types: [ImageType], imageId: Int, bgColor: UIColor) async throws -> [Data]
}

protocol RemoteRepository {
    func executeFetchRequest<T: Decodable>(ofType request: FetchRequest) async throws -> T
    func executeFetchRequest<T: Decodable>(ofType request: FetchRequest, completionHandler: @escaping (Result<T>) -> Void)
    func executeSaveRequest(ofType request: SaveRequest, completionHandler: @escaping (Result<Bool>) -> Void)
}

class ProductGatewayImpl: ProductGateway {
    
    private let operationQueue = OperationQueue()
    private let productImagesApi: ProductImagesApi
    private let remoteRepository: RemoteRepository
    
    init(productImagesApi: ProductImagesApi, remoteRepository: RemoteRepository) {
        self.remoteRepository = remoteRepository
        self.productImagesApi = productImagesApi
    }
    
    // One Product by Id
    func fetchProduct(byId productId: String, productColor: String?) async throws -> FetchProductsResult {
        var product: ProductDTO = try await remoteRepository.executeFetchRequest(
            ofType: .productById(id: productId))
        
        let imageId = product.getImageId(forColor: productColor)
        
        let images = try await productImagesApi.loadImages([.main, .front2, .main2, .perspective, .left, .back], imageId: imageId, bgColor: .appLightGray)
        
        product.images = images
        
        return ([product], 1)
    }
    
    // Products by Type, Category, Family
    func fetchProducts(type: ProductType, category: ProductCategory?, family: ProductFamily?, first: Int, skip: Int) async throws -> FetchProductsResult {
        var products: [ProductDTO] = try await remoteRepository.executeFetchRequest(
            ofType: .productsByType(name: type.rawValue))
        
        let totalCount = products.count
        
        products.filter(withCategory: category, family: family, first: first, skip: skip)
        
        try await loadImages(forProducts: &products, imageTypes: [.main], bgColor: .appLightGray)
        
        return (products, totalCount)
    }
    
    // Representation Of Product Families Of Type
    func fetchProducts(asRepresentationOfProductFamiliesOfType type: ProductType) async throws -> FetchProductsResult {
        var products: [ProductDTO] = try await remoteRepository.executeFetchRequest(ofType: .productsByType(name: type.rawValue))
        
        products = products.getFirstProductsForProductsFamilies()
        
        try await loadImages(forProducts: &products, imageTypes: [.main], bgColor: .appWhite)
        
        return (products, products.count)
    }
}

// MARK: - Fileprivate extensions

fileprivate extension ProductGatewayImpl {
    private func loadImages(forProducts products: inout [ProductDTO], imageTypes: [ImageType], bgColor: UIColor) async throws {
        try await withThrowingTaskGroup(of: (index: Int, images: [Data]).self) { taskGroup in
            for (i, product) in products.enumerated() {
                taskGroup.addTask {
                    guard let imageId = product.variations.first?.imgId else { fatalError("imageId is nil") }
                    let images = try await self.productImagesApi.loadImages(imageTypes, imageId: imageId, bgColor: bgColor)
                    return (index: i, images: images)
                }
            }
            
            for try await (i, images) in taskGroup {
                products[i].images = images
            }
        }
    }
}

fileprivate extension ProductDTO {
    func getImageId(forColor productColor: String?) -> Int {
        
        let imageId: Int?
        
        switch productColor {
        case .none:            imageId = self.variations.first?.imgId
        case .some(let color): imageId = self.variations.first(where: { $0.color == color })?.imgId }
        
        guard let imageId else { fatalError("imageId is nil") }
        
        return imageId
    }
}

fileprivate extension Array where Element == ProductDTO {
    mutating func filter(withCategory category: ProductCategory?, family: ProductFamily?, first: Int, skip: Int) {
        
        // filter products with product family
        if let family { self = self.filter { $0.family.lowercased() == family.rawValue.lowercased() }}
        
        // filter products with category
        switch category {
        case .men:
            self = self.filter { $0.gender.lowercased() == "male" || $0.gender.lowercased() == "unisex" }
        case .women:
            self = self.filter { $0.gender.lowercased() == "female" || $0.gender.lowercased() == "unisex" }
        case .kids:
            self = self.filter { $0.gender.lowercased() == "child" }
        case .none:
            break
        }
        
        //filter products with required quantity
        self = Array(self.dropFirst(skip).prefix(first))
    }
    
    func getFirstProductsForProductsFamilies() -> Self {
        return self.reduce(into: []) { result, product in
            if !result.contains(where: { $0.family == product.family }) {
                result.append(product)
            }
        }
    }
}
