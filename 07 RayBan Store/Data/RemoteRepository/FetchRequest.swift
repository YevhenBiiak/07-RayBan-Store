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
    case cartItems(userId: String)
    case orders(userId: String, limit: Int?)
    
    var path: String {
        switch self {
        case .profile(id: let id):
            return "users/\(id)"
        case .products(id: let id, _, _):
            return "products/\(id ?? "")"
        case .cartItems(userId: let id):
            return "users/\(id)/cart"
        case .orders(userId: let id, _):
            return "users/\(id)/orders"
        }
    }
    
    var queryKey: String? {
        switch self {
        case .profile:
            return nil
        case .products(_, category: let category, _):
            return category == nil ? nil : "category"
        case .cartItems:
            return nil
        case .orders:
            return nil
        }
    }
    
    var queryValue: String? {
        switch self {
        case .profile:
            return nil
        case .products(_, category: let category, _):
            return category
        case .cartItems:
            return nil
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
        case .cartItems:
            return nil 
        case .orders(_, limit: let limit):
            return limit == nil ? nil : UInt(limit!)
        }
    }
}
