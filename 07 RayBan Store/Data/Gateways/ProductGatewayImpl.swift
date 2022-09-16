//
//  ProductGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import Foundation

protocol ProductImagesApi {
    func getMainImage(forProductId productId: String, completion: @escaping (Data?, Error?) -> Void)
    func getAllImages(forProductId productId: String, completion: @escaping (ProductImages?, Error?) -> Void)
}

class ProductGatewayImpl: ProductGateway {
    
    private let productImagesApi: ProductImagesApi
    private let remoteRepository: RemoteRepository
    
    init(productImagesApi: ProductImagesApi, remoteRepository: RemoteRepository) {
        self.remoteRepository = remoteRepository
        self.productImagesApi = productImagesApi
    }
    
    // One product
    func fetchProduct(byIdentifier productId: String, completionHandler: @escaping (Result<ProductDTO>) -> Void) {
        remoteRepository.executeFetchRequest(ofType: .products(id: productId, category: nil, limit: nil)) { [weak self] (result: Result<ProductDTO>) in
            switch result {
            case .success(let product):
                self?.loadAllImagesForProduct(product, completionHandler: completionHandler)
            case .failure(let error):
                return completionHandler(.failure(error))
            }
        }
    }
    
    // All products
    func fetchProducts(first: Int, skip: Int, completionHandler: @escaping (Result<[ProductDTO]>) -> Void) {
        remoteRepository.executeFetchRequest(ofType: .products(id: nil, category: nil, limit: first)) { [weak self] (result: Result<[ProductDTO]>) in
            switch result {
            case .success(var products):
                products = Array(products.dropFirst(skip).prefix(first))
                self?.loadMainImageForProducts(products, completionHandler: completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // Products by category
    func fetchProducts(byCategoryName category: String, first: Int, skip: Int, completionHandler: @escaping (Result<[ProductDTO]>) -> Void) {
        remoteRepository.executeFetchRequest(ofType: .products(id: nil, category: category, limit: 20)) { [weak self] (result: Result<[ProductDTO]>) in
            switch result {
            case .success(var products):
                products = Array(products.dropFirst(skip).prefix(first))
                self?.loadMainImageForProducts(products, completionHandler: completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // Array of products id
    func fetchProducts(byIdentifiers identifiers: [String], first: Int, skip: Int, completionHandler: @escaping (Result<[ProductDTO]>) -> Void) {
        var products: [ProductDTO] = []
        
        for id in identifiers {
            remoteRepository.executeFetchRequest(ofType: .products(id: id, category: nil, limit: nil)) { (result: Result<ProductDTO>) in
                switch result {
                case .success(let product):
                    products.append(product)
                case .failure(let error):
                    return completionHandler(.failure(error))
                }
            }
        }
        
        products = Array(products.dropFirst(skip).prefix(first))
        loadMainImageForProducts(products, completionHandler: completionHandler)
    }
    
    // MARK: - Private methods
    
    private func loadMainImageForProducts(_ products: [ProductDTO], completionHandler: @escaping (Result<[ProductDTO]>) -> Void) {
        for product in products {
            productImagesApi.getMainImage(forProductId: product.id) { data, error in
                if let error = error {
                    return completionHandler(.failure(error))
                }
                
                if let data = data {
                    product.images?.main = data
                }
            }
        }
        completionHandler(.success(products))
    }
    
    private func loadAllImagesForProduct(_ product: ProductDTO, completionHandler: @escaping (Result<ProductDTO>) -> Void) {
        var product = product
        productImagesApi.getAllImages(forProductId: product.id) { productImages, error in
            if let error = error {
                return completionHandler(.failure(error))
            }
            
            if let images = productImages {
                product.images = images
            }
        }
        completionHandler(.success(product))
    }
}
