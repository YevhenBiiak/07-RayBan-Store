//
//  ProductImagesApiImpl.swift
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
        var images: [Data?] = Array(repeating: nil, count: types.count)
        for (i, type) in types.enumerated() {
            
            let url = configureURL(type: type, imageId: imageId, bgColor: bgColor)
            
            let task = session.dataTask(with: url) { data, response, error in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200
                else { return }
                if let error {
                    failureCompletion(error)
                } else if let data {
                    //print(i, data, Thread.current)
                    images[i] = data
                    successCompletion(images.compactMap({$0}))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Private methods
    
    private func configureURL(
        type: ImageType,
        imageId: Int,
        bgColor: UIColor
    ) -> URL {
        var imgName = "\(imageId)"
        var imgWidth = 2048
        
        switch type {
        case .main:   imgName += "__001.png"; imgWidth = 2017
        case .main2:  imgName += "__002.png"; imgWidth = 2017
        case .back:   imgName += "__STD__shad__bk.png"
        case .left:   imgName += "__STD__shad__lt.png"
        case .front:  imgName += "__STD__shad__fr.png"
        case .front2: imgName += "__STD__shad__cfr.png"
        case .perspective: imgName += "__STD__shad__al2.png"
        default: fatalError("unspecified case") }
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "images.ray-ban.com"
        urlComponent.path = "/is/image/RayBan/\(imgName)"
        urlComponent.queryItems = [
            URLQueryItem(name: "impolicy", value: "RB_Product"),
            URLQueryItem(name: "width", value: "\(imgWidth)"),
            URLQueryItem(name: "bgc", value: bgColor.hexString)]
        
        return urlComponent.url!
    }
}
