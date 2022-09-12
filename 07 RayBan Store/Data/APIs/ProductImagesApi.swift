//
//  ApiNetwork.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

class ProductImageApiImpl: ProductImagesApi {
    
    private let baseURL = URL(string: "https://images.ray-ban.com/is/image/RayBan/")
    
    func getMainImage(forProductId productId: String, completion: @escaping (Data?, Error?) -> Void) {
        let imageName = "\(productId)__001.png"
        let url = URL(string: imageName, relativeTo: baseURL)!
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, error)
        }
        task.resume()
    }
    
    func getAllImages(forProductId productId: String, completion: (ProductImages?, Error?) -> Void) {
        
    }
    
}
