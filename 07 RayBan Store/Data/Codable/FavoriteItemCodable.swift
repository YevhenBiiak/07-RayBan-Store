//
//  FavoriteItemCodable.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 12.03.2023.
//

struct FavoriteItemCodable: Codable {
    let modelID: ModelID
}

extension FavoriteItemCodable {
    init(_ model: FavoriteItem) {
        self.modelID = model.product.modelID
    }
}
