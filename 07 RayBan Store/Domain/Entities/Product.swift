//
//  Product.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

typealias Cents = Int

struct Product: Codable {
    let id: String
    let title: String
    let category: String
    let details: String
    let price: Cents
}
