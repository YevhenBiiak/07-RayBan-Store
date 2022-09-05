//
//  UpdateCartItemAmountRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

struct UpdateCartItemAmountRequest: RequestModel {
    let productId: String
    let amount: Int
}
