//
//  GetProductRequests.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

struct ProductStylesRequest {
    let category: Product.Category
}

struct ProductWithIDRequest {
    var productID: Int
}

struct ProductWithModelIDRequest {
    var modelID: String
}

struct ProductRequest {
    let category: Product.Category
    let gender: Product.Gender?
    let style: Product.Style?
    var index: Int
}

struct ProductsCountRequest {
    let category: Product.Category
    let gender: Product.Gender?
    let style: Product.Style?
}
