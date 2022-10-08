//
//  FetchRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 10.09.2022.
//

import Foundation

enum FetchRequest {
    case profile(id: String)
    case productById(id: String)
    case productsByType(name: String)
    case cartItems(userId: String)
    case orders(userId: String)

    var path: String {
        switch self {
        case .profile:            return "users"
        case .productById:        return "products"
        case .productsByType:     return "products"
        case let .cartItems(id):  return "users/\(id)/cart"
        case let .orders(userId): return "users/\(userId)/orders"
        }
    }

    var queryKey: String? {
        switch self {
        case .profile:            return nil
        case .productById:        return "id"
        case .productsByType:     return "type"
        case .cartItems:          return nil
        case .orders:             return nil
        }
    }

    var queryValue: Any? {
        switch self {
        case .profile: return nil
        case let .productById(id): return id
        case let .productsByType(name): return name
        case .cartItems: return nil
        case .orders: return nil
        }
    }
}
