//
//  ApiNetwork.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation
import UIKit

class ProductImagesApiImpl: ProductImagesApi {
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
        config.urlCache = URLCache(memoryCapacity: 100 * MB, diskCapacity: 300 * MB, diskPath: "images")
        config.httpMaximumConnectionsPerHost = 5
        return URLSession(configuration: config)
    }()
    
    // MARK: - ProductImagesApi
    
    func getMainImage(forProductId productId: Int, bgColor: UIColor, completion: @escaping (ProductImages?, Error?) -> Void) {
        let width = 500
        let hexColor = bgColor.hexString
        let images = ProductImages()
        
        loadImage(.main, forProductId: productId, width: width, hexColor: hexColor) { data, error in
            if let error = error { return completion(images, error) }
            images.main = data
            completion(images, nil)
        }
    }
    
    func getAllImages(forProductId productId: Int, bgColor: UIColor, completion: @escaping (ProductImages?, Error?) -> Void) {
        let width = 800
        let hexColor = bgColor.hexString
        let images = ProductImages()
        
        loadImage(.main, forProductId: productId, width: width, hexColor: hexColor) { data, error in
            if let error = error { return completion(images, error) }
            images.main = data
            completion(images, nil)
        }
        loadImage(.back, forProductId: productId, width: width, hexColor: hexColor) { data, error in
            if let error = error { return completion(images, error) }
            images.back = data
            completion(images, nil)
        }
        loadImage(.front, forProductId: productId, width: width, hexColor: hexColor) { data, error in
            if let error = error { return completion(images, error) }
            images.front = data
            completion(images, nil)
        }
        loadImage(.perspective, forProductId: productId, width: width, hexColor: hexColor) { data, error in
            if let error = error { return completion(images, error) }
            images.perspective = data
            completion(images, nil)
        }
        loadImage(.left, forProductId: productId, width: width, hexColor: hexColor) { data, error in
            if let error = error { return completion(images, error) }
            images.left = data
            completion(images, nil)
        }
    }
    
    // MARK: - Private methods
    
    private func loadImage(_ type: ProductImagesApiImpl.Image,
                           forProductId productId: Int,
                           width: Int,
                           hexColor: String,
                           completion: @escaping (Data?, Error?) -> Void) {
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "images.ray-ban.com"
        urlComponent.path = "/is/image/RayBan/\(productId)\(type.rawValue)"
        urlComponent.queryItems = [URLQueryItem(name: "impolicy", value: "RB_Product"),
                                   URLQueryItem(name: "width", value: "\(width)"),
                                   URLQueryItem(name: "bgc", value: hexColor)]
        guard let url = urlComponent.url else { return }
        
        let task = session.dataTask(with: url) { data, _, error in
            completion(data, error)
        }
        task.resume()
    }
}
