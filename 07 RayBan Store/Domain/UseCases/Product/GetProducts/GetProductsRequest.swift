//
//  GetProductsRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

struct GetProductsRequest {
    enum Query {
        case identifier(id: Int)
        case identifiers(ids: [Int], first: Int, skip: Int)
        case products(withType: ProductType, category: ProductCategory, family: ProductFamily, first: Int, skip: Int)
        case productFamiliesDescription(ofType: ProductType)
    }
    let query: Query
}
