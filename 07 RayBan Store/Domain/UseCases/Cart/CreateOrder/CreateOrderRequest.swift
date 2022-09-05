//
//  CreateOrderRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 05.09.2022.
//

import Foundation

struct CreateOrderRequest: RequestModel {
    let shippingAddress: String
    let shippingMethods: String
}
