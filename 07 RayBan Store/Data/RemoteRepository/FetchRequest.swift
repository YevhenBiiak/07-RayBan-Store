//
//  FetchRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 10.09.2022.
//

import Foundation

enum FetchRequest {
    case profile(id: String)
    case productById(id: Int)
    case productsByType(type: String)
    case productsByFamily(name: String)
    case productsByCategory(name: String)
    case cartItems(userId: String)
    case orders(userId: String)

    var path: String {
        switch self {
        case .profile:
            return "users"
        case .productById, .productsByType, .productsByFamily, .productsByCategory:
            return "products"
        case let .cartItems(id):
            return "users/\(id)/cart"
        case let .orders(userId):
            return "users/\(userId)/orders"
        }
    }

    var queryKey: String? {
        switch self {
        case .profile:            return nil
        case .productById:        return "id"
        case .productsByType:     return "type"
        case .productsByFamily:   return "productFamily"
        case .productsByCategory: return "category"
        case .cartItems:          return nil
        case .orders:             return nil
        }
    }

    var queryValue: Any? {
        switch self {
        case .profile: return nil
        case let .productById(id): return id
        case let .productsByType(type): return type
        case let .productsByFamily(name): return name
        case let .productsByCategory(name): return name
        case .cartItems: return nil
        case .orders: return nil
        }
    }
}
