//
//  ApiNetwork.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

class ProductImageApiImpl: ProductImagesApi {
    private enum Image: String {
        case main = "__001.png"
        case main2 = "__002.png"
        case perspective = "__STD__shad__al2.png"
        case front = "__STD__shad__fr.png"
        case frontClosed = "__STD__shad__cfr.png"
        case back = "__STD__shad__bk.png"
        case `left` = "__STD__shad__lt.png"
    }
    
    private let session: URLSession = {
        let MB = 1024 * 1024
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(memoryCapacity: 50 * MB, diskCapacity: 100 * MB, diskPath: "images")
        config.httpMaximumConnectionsPerHost = 5
        return URLSession(configuration: config)
    }()
    
    private let baseURL = "https://images.ray-ban.com/is/image/RayBan"
    
    func getMainImage(forProductId productId: String, completion: @escaping (Data?, Error?) -> Void) {
        loadImage(.main, forProductId: productId, width: 500, hexColor: "f2f2f2", completion: completion)
    }
    
    func getAllImages(forProductId productId: String, completion: @escaping (ProductImages?, Error?) -> Void) {
        let width = 800
        let hexColor = "f2f2f2"
        let images = ProductImages()
        
        loadImage(.main, forProductId: productId, width: width, hexColor: hexColor) { data, error in
            if let error = error { return completion(images, error) }
            images.main = data
        }
        loadImage(.back, forProductId: productId, width: width, hexColor: hexColor) { data, error in
            if let error = error { return completion(images, error) }
            images.back = data
        }
        loadImage(.front, forProductId: productId, width: width, hexColor: hexColor) { data, error in
            if let error = error { return completion(images, error) }
            images.front = data
        }
        loadImage(.perspective, forProductId: productId, width: width, hexColor: hexColor) { data, error in
            if let error = error { return completion(images, error) }
            images.perspective = data
        }
        loadImage(.left, forProductId: productId, width: width, hexColor: hexColor) { data, error in
            if let error = error { return completion(images, error) }
            images.left = data
        }
        
        completion(images, nil)
    }
    
    // MARK: - Private methods
    
    private func loadImage(_ type: ProductImageApiImpl.Image,
                           forProductId productId: String,
                           width: Int,
                           hexColor: String,
                           completion: @escaping (Data?, Error?) -> Void) {
        
        var urlComponent = URLComponents(string: baseURL)
        urlComponent?.path = "/\(productId)\(Image.main.rawValue)"
        urlComponent?.queryItems = [URLQueryItem(name: "impolicy", value: "RB_Product"),
                                    URLQueryItem(name: "width", value: "\(width)"),
                                    URLQueryItem(name: "bgc", value: "%23\(hexColor)")]
        
        guard let url = urlComponent?.url else { return }

        let task = session.dataTask(with: url) { data, _, error in
            completion(data, error)
        }
        task.resume()
    }
}
