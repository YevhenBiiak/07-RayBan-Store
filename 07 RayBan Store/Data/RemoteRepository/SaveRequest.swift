//
//  SaveRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 10.09.2022.
//

import Foundation

enum SaveRequest {
    case saveProfile(_ profile: ProfileDTO, userId: String)
    case saveCartItems(_ items: [CartItemDTO], userId: String)
    case saveOrder(_ order: OrderDTO, userId: String)
    
    var path: String {
        switch self {
        case .saveProfile:
            return "customers"
        case .saveCartItems:
            return "customers"
        case .saveOrder:
            return "orders"
        }
    }
    
    var key: String {
        switch self {
        case .saveProfile(_, userId: let userId):
            return userId
        case .saveCartItems(_, userId: let userId):
            return "\(userId)/cart"
        case .saveOrder(_, userId: let userId):
            return userId
        }
    }
    
    var value: DictionaryConvertible {
        switch self {
        case .saveProfile(let profile, _):
            return profile
        case .saveCartItems(let items, _):
            return items
        case .saveOrder(let order, _):
            return order
        }
    }
}
