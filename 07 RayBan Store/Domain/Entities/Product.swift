//
//  Product.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

typealias Cent = Int

struct Product {
    let id: Int
    let title: String
    let type: String
    let category: String
    let productFamily: String
    let details: String
    let price: Cent
}
