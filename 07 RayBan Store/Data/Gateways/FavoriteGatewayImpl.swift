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
        var favoriteItems: [FavoriteItem?] = Array(repeating: nil, count: items.count)
        try await withThrowingTaskGroup(of: (index: Int, product: Product).self) { taskGroup in

            for (i, modelID) in items.enumerated() {
                taskGroup.addTask {
                    let product = try await self.productGateway.fetchProduct(modelID: modelID, includeImages: includeImages)
                    return (index: i, product: product)
                }
            }
            for try await (i, product) in taskGroup {
                favoriteItems[i] = FavoriteItem(product: product)
            }
        }
        return favoriteItems.compactMap {$0}
    }
    
    func saveFavoriteItems(_ items: [FavoriteItem], for user: User) async throws {
        let items = items.compactMap { $0.product.modelID }
        try await favoriteItemsAPI.saveFavoriteItems(items, for: user)
    }
}
