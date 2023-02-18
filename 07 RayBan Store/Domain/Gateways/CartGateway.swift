//
//  CartGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

protocol CartGateway {
    func fetchCartItems(for user: User, includeImages: Bool) async throws -> [CartItem]
    func saveCartItems(_ items: [CartItem], for user: User) async throws
    func saveOrder(_ order: Order, for user: User) async throws
}
