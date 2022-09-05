//
//  AddCartItemRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

struct AddCartItemRequest: RequestModel {
    let productDTO: ProductDTO
    let amount: Int
}
