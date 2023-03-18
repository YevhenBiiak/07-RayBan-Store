//
//  GetProductRequests.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

struct ProductStylesRequest {
    let category: Product.Category
    let options: ImageOption
}

struct ProductWithIDRequest {
    let productID: Int
    let options: ImageOption
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

struct ProductsRequest {
    let category: Product.Category
    let gender: Product.Gender?
    let style: Product.Style?
    var range: Range<Int>
}

struct ProductsCountRequest {
    let category: Product.Category
    let gender: Product.Gender?
    let style: Product.Style?
}
