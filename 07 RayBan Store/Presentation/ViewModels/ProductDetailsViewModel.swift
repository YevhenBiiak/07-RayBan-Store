//
//  ProductDetailsViewModel.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 21.02.2023.
//

import UIKit

struct ProductDetailsViewModel {
    let modelID: String
    let productID: Int
    let name: String
    let category: String
    let gender: String
    let style: String
    let size: String
    let geofit: String
    let colors: [String]
    let frameColor: String
    let lenseColor: String
    let selectedColorIndex: Int
    let price: String
    let details: String
    let imageData: [Data]
}
