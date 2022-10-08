//
//  ProductVM.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 22.09.2022.
//

import Foundation

struct ProductVM {
    let id: String
    let name: String
    let type: String
    let family: String
    let gender: String
    let size: String
    let geofit: String
    let variations: [ProductVariantVM]
    let details: String
    var images: [Data]
}

struct ProductVariantVM {
    let frameColor: String
    let lenseColor: String
    var color: String { "\(frameColor)/\(lenseColor)" }
    let price: Int
    let imgId: Int
}
