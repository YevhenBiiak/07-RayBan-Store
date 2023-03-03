//
//  FavoriteGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 24.02.2023.
//

protocol FavoriteItemsAPI {
    func fetchFavoriteItems(for user: User) async throws -> [ModelID]
    func saveFavoriteItems(_ items: [ModelID], for user: User) async throws
}

class FavoriteGatewayImpl {
    
    private let favoriteItemsAPI: FavoriteItemsAPI
    private let productGateway: ProductGateway
    
    init(favoriteAPI: FavoriteItemsAPI, productGateway: ProductGateway) {
        self.favoriteItemsAPI = favoriteAPI
        self.productGateway = productGateway
    }
}

extension FavoriteGatewayImpl: FavoriteGateway {
    
    func fetchFavoriteItems(for user: User, includeImages: Bool) async throws -> [FavoriteItem] {
        let items = try await favoriteItemsAPI.fetchFavoriteItems(for: user)
        let favoriteItems = try await items.concurrentMap { [unowned self] modelID in
            let product = try await productGateway.fetchProduct(modelID: modelID, includeImages: includeImages)
            return FavoriteItem(product: product)
        }
        return favoriteItems
    }
    
    func saveFavoriteItems(_ items: [FavoriteItem], for user: User) async throws {
        let items = items.compactMap { $0.product.modelID }
        try await favoriteItemsAPI.saveFavoriteItems(items, for: user)
    }
}
