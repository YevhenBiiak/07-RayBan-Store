//
//  ProductImageDataDTO.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

struct ProductImageDataDTO: Codable {
    let image001: Data?
    let image002: Data?
    let imagePersp: Data?
    let imageFront: Data?
    let imageCFront: Data?
    let imageBack: Data?
    let imageLeft: Data?
}
