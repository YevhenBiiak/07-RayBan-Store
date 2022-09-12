//
//  FetchRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 10.09.2022.
//

import Foundation

enum FetchRequest {
    case profile(id: String)
    case products(id: String?, category: String?, limit: Int?)
    case orders
    
    var path: String {
        switch self {
        case .profile:
            return "customers"
        case .products:
            return "products"
        case .orders:
            return "orders"
        }
    }
    
    var key: String? {
        switch self {
        case .profile(id: let id):
            return id
        case .products(id: let id, _, _):
            return id
        case .orders:
            return nil
        }
    }
    
    var value: String? {
        switch self {
        case .profile:
            return nil
        case .products(_, category: let category, _):
            return category
        case .orders:
            return nil
        }
    }
    
    var limit: UInt? {
        switch self {
        case .profile:
            return nil
        case .products(_, _, limit: let limit):
            return limit == nil ? nil : UInt(limit!)
        case .orders:
            return nil
        }
    }
}
