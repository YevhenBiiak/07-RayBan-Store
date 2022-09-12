//
//  GetProductsRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

struct GetProductsRequest {
    enum QueryType {
        case identifier(id: String)
        case all(first: Int, skip: Int)
        case category(name: String, first: Int, skip: Int)
        case identifiers(ids: [String], first: Int, skip: Int)
    }
    let query: QueryType
}
