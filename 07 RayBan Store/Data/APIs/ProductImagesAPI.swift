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
        bgColor: UIColor
    ) async throws -> [Data] {
        try await types.concurrentMap { type in
            let url = self.configureURL(type: type, imageId: imageId, bgColor: bgColor)
            let (data, response) = try await self.session.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { return nil }
            return data
        }.compactMap({$0})
    }
    
    // MARK: - Private methods
    
    private func configureURL(
        type: ImageType,
        imageId: Int,
        bgColor: UIColor
    ) -> URL {
        var imgName = "\(imageId)"
        var imgWidth = 2048
        // https://images.ray-ban.com/is/image/RayBan/8056597786683__001.png
        switch type {
        case .main:   imgName += "__001.png"; imgWidth = 500
        case .main2:  imgName += "__002.png"
        case .back:   imgName += "__STD__shad__bk.png"
        case .left:   imgName += "__STD__shad__lt.png"
        case .front:  imgName += "__STD__shad__fr.png"
        case .front2: imgName += "__STD__shad__cfr.png"
        case .perspective: imgName += "__STD__shad__al2.png" }
        
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
