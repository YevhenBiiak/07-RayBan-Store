//
//  FavoriteRequests.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 25.02.2023.
//

struct IsItemInFavoriteRequset {
    let user: User
    let product: Product
}

struct GetFavoriteItemsRequest {
    let user: User
}

struct AddFavoriteItemRequest {
    let user: User
    let product: Product
}

struct DeleteFavoriteItemRequest {
    let user: User
    let modelID: ModelID
    let includeImages: Bool
}
