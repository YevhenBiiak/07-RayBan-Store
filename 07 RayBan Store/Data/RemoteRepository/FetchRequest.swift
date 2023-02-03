//
//  FetchRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 10.09.2022.
//

import Foundation

enum FetchRequest<T> {
    
    case fetchProfile(id: String, type: T.Type)
    case fetchProduct(id: String, type: T.Type)
    case fetchProducts(category: String, type: T.Type)
    case fetchCartItems(userId: String, type: T.Type)
    case fetchOrders(userId: String, type: T.Type)
    
    var path: String {
        switch self {
        case .fetchProfile:               return "users"
        case .fetchProduct:               return "products"
        case .fetchProducts:              return "products"
        case .fetchCartItems(let id, _):  return "users/\(id)/cart"
        case .fetchOrders(let id, _):     return "users/\(id)/orders"
        }
    }

    var queryKey: String? {
        switch self {
        case .fetchProfile:   return nil
        case .fetchProduct:   return "id"
        case .fetchProducts:  return "type"
        case .fetchCartItems: return nil
        case .fetchOrders:    return nil
        }
    }

    var queryValue: Any? {
        switch self {
        case .fetchProfile: return nil
        case .fetchProduct(let id, _): return id
        case .fetchProducts(let category, _): return category
        case .fetchCartItems: return nil
        case .fetchOrders: return nil
        }
    }
}
