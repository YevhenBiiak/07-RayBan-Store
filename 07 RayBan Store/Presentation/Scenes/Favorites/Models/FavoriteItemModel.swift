//
//  FavoriteItemModel.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 01.03.2023.
//

import Foundation

struct FavoriteSection: Sectionable {
    var header: String?
    var items: [any Itemable]
}

struct FavoriteSectionItem: Itemable {
    var viewModel: FavoriteItemViewModel?
}

struct FavoriteItemModel: FavoriteItemViewModel {
    let modelID: ModelID
    let name: String
    let price: String
    let frame: String
    let lense: String
    let size: String
    let imageData: Data
    let favoriteButtonTapped: (ModelID) async -> Void
}
