//
//  DeleteCartItemResponse.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.09.2022.
//

import Foundation

struct DeleteCartItemResponse: ResponseModel {
    let cartItems: [CartItemDTO]
}
