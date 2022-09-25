//
//  FetchRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 10.09.2022.
//

import Foundation

enum FetchRequest {
    case profile(id: String)
    case products(limit: UInt)
    case productById(id: Int)
    case productsByCategory(category: String, limit: UInt)
    case cartItems(userId: String)
    case orders(userId: String, limit: UInt)

    var path: String {
        switch self {
        case .profile:
            return "users"
        case .products, .productById, .productsByCategory:
            return "products"
        case .cartItems(userId: let id):
            return "users/\(id)/cart"
        case .orders(userId: let id, _):
            return "users/\(id)/orders"
        }
    }

    var queryKey: String? {
        switch self {
        case .profile: return nil
        case .products: return nil
        case .productById: return "id"
        case .productsByCategory: return "category"
        case .cartItems: return nil
        case .orders: return nil
        }
    }

    var queryValue: Any? {
        switch self {
        case .profile: return nil
        case .products: return nil
        case .productById(id: let id): return id
        case .productsByCategory(category: let category, _): return category
        case .cartItems: return nil
        case .orders: return nil
        }
    }

    var limit: UInt? {
        switch self {
        case .profile: return nil
        case .products(limit: let limit): return limit
        case .productById: return nil
        case .productsByCategory(_, limit: let limit): return limit
        case .cartItems: return nil
        case .orders(_, limit: let limit): return limit
        }
    }
}
