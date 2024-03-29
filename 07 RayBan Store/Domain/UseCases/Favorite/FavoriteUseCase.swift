//
//  FavoriteUseCase.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 25.02.2023.
//

protocol FavoriteUseCase {
    func execute(_ request: IsItemInFavoriteRequset) async throws -> Bool
    func execute(_ request: GetFavoriteItemsRequest) async throws -> [FavoriteItem]
    func execute(_ request: AddFavoriteItemRequest) async throws
    @discardableResult
    func execute(_ request: DeleteFavoriteItemRequest) async throws -> [FavoriteItem]
}

class FavoriteUseCaseImpl {
    
    private let favoriteGateway: FavoriteGateway
    
    init(favoriteGateway: FavoriteGateway) {
        self.favoriteGateway = favoriteGateway
    }
}

extension FavoriteUseCaseImpl: FavoriteUseCase {
    
    func execute(_ request: IsItemInFavoriteRequset) async throws -> Bool {
        let favoriteItems = try await favoriteGateway.fetchFavoriteItems(for: request.user, options: .noImages)
        let favoriteList = FavoritList(items: favoriteItems)
        return favoriteList.contains(request.product)
    }
    
    func execute(_ request: GetFavoriteItemsRequest) async throws -> [FavoriteItem] {
        try await favoriteGateway.fetchFavoriteItems(for: request.user, options: .image(res: .low))
    }
    
    func execute(_ request: AddFavoriteItemRequest) async throws {
        let favoriteItems = try await favoriteGateway.fetchFavoriteItems(for: request.user, options: .noImages)
        var favoriteList = FavoritList(items: favoriteItems)
        favoriteList.add(product: request.product)
        try await favoriteGateway.saveFavoriteItems(favoriteList.items, for: request.user)
    }
    
    func execute(_ request: DeleteFavoriteItemRequest) async throws -> [FavoriteItem] {
        let favoriteItems = try await favoriteGateway.fetchFavoriteItems(for: request.user, options: request.options)
        var favoriteList = FavoritList(items: favoriteItems)
        favoriteList.delete(modelID: request.modelID)
        try await favoriteGateway.saveFavoriteItems(favoriteList.items, for: request.user)
        return favoriteList.items
    }
}
