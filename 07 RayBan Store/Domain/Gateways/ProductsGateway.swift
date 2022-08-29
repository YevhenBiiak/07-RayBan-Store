//
//  ProductsGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

protocol ProductsGateway {
    func fetchProducts(completionHandler: @escaping (Result<[Product]>) -> Void)
}
