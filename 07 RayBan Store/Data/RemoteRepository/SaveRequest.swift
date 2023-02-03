//
//  SaveRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 10.09.2022.
//

import Foundation

enum SaveRequest {
    case saveProfile(_ profile: ProfileDTO)
    // case cartItems(_ items: [CartItemDTO], userId: String)
    // case order(_ order: OrderDTO, userId: String)
    
    var path: String {
        switch self {
        case .saveProfile: return "customers"
            // case .cartItems:   return "customers"
            // case .order:       return "orders"
        }
    }
    
    var key: String {
        switch self {
        case .saveProfile(let profile):         return profile.id
            // case .cartItems(_, userId: let userId): return "\(userId)/cart"
            // case .order(_, userId: let userId):     return userId
        }
    }
    
    var value: DictionaryConvertible {
        switch self {
        case .saveProfile(let profile): return profile
            // case .cartItems(let items, _):  return items
            // case .order(let order, _):      return order
        }
    }
}
