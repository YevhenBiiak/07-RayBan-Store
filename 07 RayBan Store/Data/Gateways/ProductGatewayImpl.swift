//
//  ProductGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import UIKit

protocol ProductImagesApi {
    func getMainImage(forProductId productId: Int, bgColor: UIColor, completion: @escaping (ProductImages?, Error?) -> Void)
    func getAllImages(forProductId productId: Int, bgColor: UIColor, completion: @escaping (ProductImages?, Error?) -> Void)
}

protocol RemoteRepository {
    func executeFetchRequest<T: Decodable>(ofType request: FetchRequest, completionHandler: @escaping (Result<T>) -> Void)
    func executeSaveRequest(ofType request: SaveRequest, completionHandler: @escaping (Result<Bool>) -> Void)
}

// swiftlint:disable opening_brace
// swiftlint:disable closure_parameter_position
class ProductGatewayImpl: ProductGateway {
    
    private let productImagesApi: ProductImagesApi
    private let remoteRepository: RemoteRepository
    
    init(productImagesApi: ProductImagesApi, remoteRepository: RemoteRepository) {
        self.remoteRepository = remoteRepository
        self.productImagesApi = productImagesApi
    }
    
    // One product by id
    func fetchProduct(
        byIdentifier productId: Int,
        completionHandler: @escaping (Result<FetchProductsResult>) -> Void)
    {
        remoteRepository.executeFetchRequest(ofType: .productById(id: productId)) {
            [weak self] (result: Result<ProductDTO>) in
            
            switch result {
            case .success(let product):
                let result = ([product], 1)
                completionHandler(.success(result))
                
                self?.loadAllImagesForProduct(product, completionHandler: completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // Products by byIdentifiers
    func fetchProducts(
        byIdentifiers identifiers: [Int], first: Int, skip: Int,
        completionHandler: @escaping (Result<FetchProductsResult>) -> Void)
    {
        var products: [ProductDTO] = []
        
        for id in identifiers.dropFirst(skip).prefix(first) {
            remoteRepository.executeFetchRequest(ofType: .productById(id: id)) { (result: Result<ProductDTO>) in
                switch result {
                case .success(let product):
                    products.append(product)
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
        
        let result = (products, identifiers.count)
        completionHandler(.success(result))
        
        loadMainImageForProducts(products, totalCount: identifiers.count, bgColor: UIColor.appGray, completionHandler: completionHandler)
    }
    
    // Products by type, category, family
    func fetchProducts(
        type: ProductType, category: ProductCategory, family: ProductFamily, first: Int, skip: Int,
        completionHandler: @escaping (Result<FetchProductsResult>) -> Void)
    {
        let typeString = type.rawValue
        remoteRepository.executeFetchRequest(ofType: .productsByType(type: typeString)) {
            [weak self] (result: Result<[ProductDTO]>) in
            
            switch result {
            case .success(var products):
                
                if category != .all { products = products.filter { $0.category.lowercased() == category.rawValue } }
                if family != .all { products = products.filter { $0.productFamily.lowercased() == family.rawValue } }
                
                let totalCount = products.count
                let result = (products, totalCount)
                completionHandler(.success(result))
                
                products = Array(products.dropFirst(skip).prefix(first))
                self?.loadMainImageForProducts(products, totalCount: totalCount, bgColor: UIColor.appGray, completionHandler: completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // Description Of Product Families Of Type
    func fetchProducts(
        asDescriptionOfProductFamiliesOfType type: ProductType,
        completionHandler: @escaping (Result<FetchProductsResult>) -> Void)
    {
        let typeString = type.rawValue
        remoteRepository.executeFetchRequest(ofType: .productsByType(type: typeString)) {
            [weak self] (result: (Result<[ProductDTO]>)) in
            
            switch result {
            case .success(var products):

                products = products.reduce(into: []) { result, product in
                    let currentFamily = product.productFamily
                    let selectedFamilies = result.map { $0.productFamily }
                    
                    if !selectedFamilies.contains(where: { $0 == currentFamily }) {
                        result.append(product)
                    }
                }
                
                let result = (products, products.count)
                completionHandler(.success(result))
                
                self?.loadMainImageForProducts(products, totalCount: products.count, bgColor: UIColor.appWhite, completionHandler: completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // MARK: - Private methods
    
    private func loadMainImageForProducts(
        _ products: [ProductDTO], totalCount: Int, bgColor: UIColor,
        completionHandler: @escaping (Result<FetchProductsResult>) -> Void)
    {
        var products = products
        for (index, product) in products.enumerated() {
            products[index].images = ProductImages()
            
            productImagesApi.getMainImage(forProductId: product.id, bgColor: bgColor) { productImages, error in
                if let error = error {
                    return completionHandler(.failure(error))
                }
                
                if let images = productImages {
                    products[index].images = images
                    let result = (products, totalCount)
                    completionHandler(.success(result))
                }
            }
        }
    }
    
    private func loadAllImagesForProduct(
        _ product: ProductDTO,
        completionHandler: @escaping (Result<FetchProductsResult>) -> Void)
    {
        var product = product
        productImagesApi.getAllImages(forProductId: product.id, bgColor: UIColor.appGray) { productImages, error in
            if let error = error {
                return completionHandler(.failure(error))
            }
            
            if let images = productImages {
                product.images = images
                let result = ([product], 1)
                completionHandler(.success(result))
            }
        }
    }
}
