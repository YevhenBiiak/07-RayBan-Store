//
//  ProductGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import Foundation

protocol ProductImagesApi {
    func getMainImage(forProductId productId: Int, completion: @escaping (ProductImages?, Error?) -> Void)
    func getAllImages(forProductId productId: Int, completion: @escaping (ProductImages?, Error?) -> Void)
}

class ProductGatewayImpl: ProductGateway {
    
    private let productImagesApi: ProductImagesApi
    private let remoteRepository: RemoteRepository
    
    init(productImagesApi: ProductImagesApi, remoteRepository: RemoteRepository) {
        self.remoteRepository = remoteRepository
        self.productImagesApi = productImagesApi
    }
    
    // One product
    func fetchProduct(byIdentifier productId: Int, completionHandler: @escaping (Result<ProductDTO>) -> Void) {
        remoteRepository.executeFetchRequest(ofType: .productById(id: productId)) { [weak self] (result: Result<ProductDTO>) in
            switch result {
            case .success(let product):
                completionHandler(.success(product))
                
                self?.loadAllImagesForProduct(product, completionHandler: completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // All products
    func fetchProducts(first: Int, skip: Int, completionHandler: @escaping (Result<[ProductDTO]>) -> Void) {
        remoteRepository.executeFetchRequest(ofType: .products(limit: UInt(first) + UInt(skip))) { [weak self] (result: Result<[ProductDTO]>) in
            switch result {
            case .success(var products):
                products = Array(products.dropFirst(skip).prefix(first))
                completionHandler(.success(products))
                
                self?.loadMainImageForProducts(products, completionHandler: completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // Products by category
    func fetchProducts(byCategoryName category: String, first: Int, skip: Int, completionHandler: @escaping (Result<[ProductDTO]>) -> Void) {
        remoteRepository.executeFetchRequest(ofType: .productsByCategory(category: category, limit: UInt(first) + UInt(skip))) { [weak self] (result: Result<[ProductDTO]>) in
            switch result {
            case .success(var products):
                products = Array(products.dropFirst(skip).prefix(first))
                completionHandler(.success(products))
                
                self?.loadMainImageForProducts(products, completionHandler: completionHandler)
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // Array of products id
    func fetchProducts(byIdentifiers identifiers: [Int], first: Int, skip: Int, completionHandler: @escaping (Result<[ProductDTO]>) -> Void) {
        var products: [ProductDTO] = []
        
        for id in identifiers {
            remoteRepository.executeFetchRequest(ofType: .productById(id: id)) { (result: Result<ProductDTO>) in
                switch result {
                case .success(let product):
                    products.append(product)
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
        
        products = Array(products.dropFirst(skip).prefix(first))
        completionHandler(.success(products))
        
        loadMainImageForProducts(products, completionHandler: completionHandler)
    }
    
    // MARK: - Private methods
    
    private func loadMainImageForProducts(_ products: [ProductDTO], completionHandler: @escaping (Result<[ProductDTO]>) -> Void) {
        var products = products
        
        for (index, product) in products.enumerated() {
            products[index].images = ProductImages()
            
            productImagesApi.getMainImage(forProductId: product.id) { productImages, error in
                if let error = error {
                    return completionHandler(.failure(error))
                }
                
                if let images = productImages {
                    products[index].images = images
                    completionHandler(.success(products))
                }
            }
        }
    }
    
    private func loadAllImagesForProduct(_ product: ProductDTO, completionHandler: @escaping (Result<ProductDTO>) -> Void) {
        var product = product
        
        productImagesApi.getAllImages(forProductId: product.id) { productImages, error in
            if let error = error {
                return completionHandler(.failure(error))
            }
            
            if let images = productImages {
                product.images = images
                completionHandler(.success(product))
            }
        }
    }
}
