//
//  GetProductsRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

struct GetProductsRequest {
    enum Query {
        case id(String)
        case color(String)
        case type(ProductType)
        case family(ProductFamily)
        case category(ProductCategory)
        case limit(first: Int, skip: Int)
        case representationOfProductFamilies(ofType: ProductType)
    }
    
    var queries: [Query]
    
    init(queries: Query...) {
        self.queries = queries
    }
    
    mutating func addQuery(query: Query) {
        self.queries.append(query)
    }
}
