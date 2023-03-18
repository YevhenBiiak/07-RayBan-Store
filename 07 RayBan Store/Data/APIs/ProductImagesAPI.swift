//
//  ProductImagesApiImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import UIKit

enum ImageType: CaseIterable {
    case main, main2, back, front, left, front2, perspective
}

enum ImageResolution { case low, medium, height, max }

class ProductImagesApiImpl: ImagesAPI {
    
    private let session: URLSession = {
        let MB = 1024 * 1024
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(memoryCapacity: 100 * MB, diskCapacity: 300 * MB, diskPath: "images")
        config.httpMaximumConnectionsPerHost = 5
        return URLSession(configuration: config)
    }()
    
    // MARK: - ProductImagesAPI
    
    func loadImages(
        _ types: [ImageType],
        imageId: Int,
        imageRes: ImageResolution,
        bgColor: UIColor
    ) async throws -> [Data] {
        try await types.concurrentMap { type in
            let url = self.configureURL(type: type, imageId: imageId, imageRes: imageRes, bgColor: bgColor)
            let (data, response) = try await self.session.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
            return data
        }.compactMap({$0})
    }
    
    // MARK: - Private methods
    
    private func configureURL(
        type: ImageType,
        imageId: Int,
        imageRes: ImageResolution,
        bgColor: UIColor
    ) -> URL {
        
        let imgName: String
        switch type {
        case .main:   imgName = "\(imageId)__001.png"
        case .main2:  imgName = "\(imageId)__002.png"
        case .back:   imgName = "\(imageId)__STD__shad__bk.png"
        case .left:   imgName = "\(imageId)__STD__shad__lt.png"
        case .front:  imgName = "\(imageId)__STD__shad__fr.png"
        case .front2: imgName = "\(imageId)__STD__shad__cfr.png"
        case .perspective: imgName = "\(imageId)__STD__shad__al2.png" }
        
        let imgWidth: String
        switch imageRes {
        case .low:    imgWidth = "320"
        case .medium: imgWidth = "640"
        case .height: imgWidth = "1024"
        case .max:    imgWidth = "2048" }
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "images.ray-ban.com"
        urlComponent.path = "/is/image/RayBan/\(imgName)"
        urlComponent.queryItems = [
            URLQueryItem(name: "impolicy", value: "RB_Product"),
            URLQueryItem(name: "width", value: "\(imgWidth)"),
            URLQueryItem(name: "bgc", value: bgColor.hexString)
        ]
        
        return urlComponent.url!
    }
}
