//
//  FetchProductsResponse.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

struct FetchProductsResponse: ResponseModel {
    let products: [ProductDTO]
}
