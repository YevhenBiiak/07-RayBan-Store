//
//  SaveRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 10.09.2022.
//

import Foundation

enum SaveRequest {
    case profile(_ profile: ProfileDTO, userId: String)
    case cartItems(_ items: [CartItemDTO], userId: String)
    case order(_ order: OrderDTO, userId: String)
    
    var path: String {
        switch self {
        case .profile:
            return "users"
        case .cartItems:
            return "users"
        case .order:
            return "orders"
        }
    }
    
    var key: String {
        switch self {
        case .profile(_, userId: let userId):
            return userId
        case .cartItems(_, userId: let userId):
            return "\(userId)/cart"
        case .order(_, userId: let userId):
            return userId
        }
    }
    
    var value: DictionaryConvertible {
        switch self {
        case .profile(let profile, _):
            return profile
        case .cartItems(let items, _):
            return items
        case .order(let order, _):
            return order
        }
    }
}
