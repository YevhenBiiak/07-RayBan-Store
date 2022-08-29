//
//  Product.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

struct Product: Codable {
    let id: String
    let name: String
    let category: String
    let price: Int
}
