//
//  RemoteRepositoryAPI.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation
import FirebaseDatabase

protocol RemoteRepositoryAPI {}

class RemoteRepositoryImpl: RemoteRepositoryAPI {
    
    private let database: DatabaseReference = Database.database().reference()
    
    private var isProductsObserved = false
    private var products: [ProductCodable] = []
    
    private var isCartItemsObserved = false
    private var cartItems: [CartItemCodable] = []
    
    private var isFavoriteItemsObserved = false
    private var favoriteItems: [FavoriteItemCodable] = []
}

// MARK: - ProfilesAPI

extension RemoteRepositoryImpl: ProfilesAPI {
    
    func fetchProfile(for user: User) async throws -> ProfileCodable {
        try await with(errorHandler) {
            try await database.child("customers").child(user.id).value.decode(ProfileCodable.self)
        }
    }
    
    func saveProfile(_ profile: ProfileCodable) async throws {
        return try await with(errorHandler) {
            try await database.child("customers").child(profile.id).updateChildValues(profile.asFIRDictionary)
        }
    }
}

// MARK: - ProductsAPI

extension RemoteRepositoryImpl: ProductsAPI {
    
    func fetchProducts() async throws -> [ProductCodable] {
        guard products.isEmpty else { return products }
        let products = try await with(errorHandler) {
            try await self.database.child("products").value.decodeArray(of: ProductCodable.self)
        }
        
        if isProductsObserved { return products }
        isProductsObserved = true
        database.child("products").observe(.value) { [weak self] snapshot in
            do {
                self?.products = try snapshot.value.decodeArray(of: ProductCodable.self)
            } catch {}
        }
        return products
    }
}

// MARK: - CartAPI

extension RemoteRepositoryImpl: CartAPI {
    
    func saveCartItems(_ items: [CartItemCodable], for user: User) async throws {
        return try await with(errorHandler) {
            try await database.child("carts").child(user.id).setValue(items.asFIRArray)
        }
    }
    
    func fetchCartItems(for user: User) async throws -> [CartItemCodable] {
        guard cartItems.isEmpty else { return cartItems }
        let cartItems = try await with(errorHandler) {
            try await database.child("carts").child(user.id).value
                .decodeArray(of: CartItemCodable.self)
        }
        
        if isCartItemsObserved { return cartItems }
        isCartItemsObserved = true
        database.child("carts").child(user.id).observe(.value) { [weak self] snapshot in
            do {
                self?.cartItems = try snapshot.value.decodeArray(of: CartItemCodable.self)
            } catch {}
        }
        return cartItems
    }
}

// MARK: - OrderAPI

extension RemoteRepositoryImpl: OrderAPI {
    
    func fetchOrders(for user: User) async throws -> [OrderCodable] {
        try await with(errorHandler) {
            try await database.child("orders").child(user.id).value
                .decodeArray(of: OrderCodable.self)
        }
    }
    
    func saveOrders(_ orders: [OrderCodable], for user: User) async throws {
        return try await with(errorHandler) {
            try await database.child("orders").child(user.id).setValue(orders.asFIRArray)
        }
    }
    
    func fetchShippingMethods() async throws -> [ShippingMethodCodable] {
        try await with(errorHandler) {
            try await database.child("shipping").value.decode([ShippingMethodCodable].self)
        }
    }
}

// MARK: - FavoriteItemsAPI

extension RemoteRepositoryImpl: FavoriteItemsAPI {
    
    func saveFavoriteItems(_ items: [FavoriteItemCodable], for user: User) async throws {
        return try await with(errorHandler) {
            try await database.child("favorites").child(user.id).setValue(items.asFIRArray)
        }
    }
    
    func fetchFavoriteItems(for user: User) async throws -> [FavoriteItemCodable] {
        guard favoriteItems.isEmpty else { return favoriteItems }
        let favoriteItems = try await with(errorHandler) {
            try await database.child("favorites").child(user.id).value
                .decodeArray(of: FavoriteItemCodable.self)
        }
        
        if isFavoriteItemsObserved { return favoriteItems }
        isFavoriteItemsObserved = true
        database.child("favorites").child(user.id).observe(.value) { [weak self] snapshot in
            do {
                self?.favoriteItems = try snapshot.value.decodeArray(of: FavoriteItemCodable.self)
            } catch {}
        }
        return favoriteItems
    }
}

// MARK: - Private extension for helper methods

private extension RemoteRepositoryImpl {
    
    func errorHandler(_ error: Error) -> Error {
        error.localizedDescription == "Permission Denied"
            ? AppError.permissionsDenied
            : AppError.unknown(error)
    }
}

extension DatabaseReference {
    var value: Any? {
        get async throws {
            try await withCheckedThrowingContinuation { continuation in
                observeSingleEvent(of: .value) { snapshot in
                    continuation.resume(returning: snapshot.value)
                } withCancel: { error in
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

extension Any? {
    func decode<T: Decodable>(_ type: T.Type) throws -> T {
        let data = try JSONSerialization.data(withJSONObject: self as Any)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func decodeArray<T: Decodable>(of type: T.Type) throws -> [T] {
        if self is NSNull { return [] }
        
        let data = try JSONSerialization.data(withJSONObject: self as Any)
        return try JSONDecoder().decode([T].self, from: data)
    }
}

private extension Array where Element: Codable {
    var asFIRArray: [String: Any] {
        var array = [String: Any]()
        for (i, item) in self.enumerated() {
            array["\(i)"] = item.asFIRDictionary
        }
        return array
    }
}

extension Encodable {
    var asFIRDictionary: [String: Any] {
        guard let jsonData = try? JSONEncoder().encode(self) else { return [:] }
        guard let dictionary = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else { return [:] }
        return dictionary
    }
}
