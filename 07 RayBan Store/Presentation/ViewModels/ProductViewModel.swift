//
//  ProductViewModel.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 22.09.2022.
//

import Foundation

struct ProductViewModel {
    let id: Int
    let title: String
    let type: String
    let category: String
    let productFamily: String
    let details: String
    let price: Int
    var images: [Data]
}
