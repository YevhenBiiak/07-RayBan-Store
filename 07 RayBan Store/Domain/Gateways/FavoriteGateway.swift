//
//  FavoriteGateway.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 24.02.2023.
//

protocol FavoriteGateway {
    func fetchFavoriteItems(for user: User, includeImages: Bool) async throws -> [FavoriteItem]
    func saveFavoriteItems(_ items: [FavoriteItem], for user: User) async throws
}
