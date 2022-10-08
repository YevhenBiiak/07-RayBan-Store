//
//  ApiNetwork.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import UIKit

class ProductImagesApiImpl: ProductImagesApi {
    
    private let session: URLSession = {
        let MB = 1024 * 1024
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(memoryCapacity: 100 * MB, diskCapacity: 300 * MB, diskPath: "images")
        config.httpMaximumConnectionsPerHost = 5
        return URLSession(configuration: config)
    }()
    
    // MARK: - ProductImagesApi
    
    func loadImages(
        _ types: [ImageType],
        imageId: Int,
        bgColor: UIColor,
        failureCompletion: @escaping (Error) -> Void,
        successCompletion: @escaping ([Data]) -> Void
    ) {
        var images: [Data] = []
        for type in types {
            var imgName = "\(imageId)"
            var imgWidth = 800
            
            switch type {
            case .main:   imgName += "__001.png"; imgWidth = 500
            case .main2:  imgName += "__002.png"; imgWidth = 500
            case .back:   imgName += "__STD__shad__bk.png"
            case .left:   imgName += "__STD__shad__lt.png"
            case .front:  imgName += "__STD__shad__fr.png"
            case .front2: imgName += "__STD__shad__cfr.png"
            case .perspective: imgName += "__STD__shad__al2.png"}
            
            loadImage(imgName: imgName, imgWidth: imgWidth, hexColor: bgColor.hexString,
            failureCompletion: { error in
                failureCompletion(error)
            }, successCompletion: { data in
                images.append(data)
                successCompletion(images)
            })
        }
    }
    
    // MARK: - Private methods
    
    private func loadImage(
        imgName: String,
        imgWidth: Int,
        hexColor: String,
        failureCompletion: @escaping (Error) -> Void,
        successCompletion: @escaping (Data) -> Void
    ) {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "images.ray-ban.com"
        urlComponent.path = "/is/image/RayBan/\(imgName)"
        urlComponent.queryItems = [
            URLQueryItem(name: "impolicy", value: "RB_Product"),
            URLQueryItem(name: "width", value: "\(imgWidth)"),
            URLQueryItem(name: "bgc", value: hexColor)]
        
        guard let url = urlComponent.url else { return }
        
        let task = session.dataTask(with: url) { data, _, error in
            if let error {
                failureCompletion(error)
            } else if let data {
                successCompletion(data)
            }
        }
        task.resume()
    }
}
