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
    private var products: [Product] = []
    
    private var isCartItemsObserved = false
    private var cartItems: [(productID: Int, amount: Int)] = []
    
    private var isFavoriteItemsObserved = false
    private var favoriteItems: [ModelID] = []
}

// MARK: - ProfilesAPI

extension RemoteRepositoryImpl: ProfilesAPI {
    
    func fetchProfile(for user: User) async throws -> Profile {
        try await with(errorHandler) {
            try await database.child("customers").child(user.id).value.decode(Profile.self)
        }
    }
    
    func saveProfile(_ profile: Profile) async throws {
        return try await with(errorHandler) {
            try await database.child("customers").child(profile.id).updateChildValues(profile.asDictionary)
        }
    }
}

// MARK: - ProductsAPI

extension RemoteRepositoryImpl: ProductsAPI {
    
    func fetchProducts() async throws -> [Product] {
        guard products.isEmpty else { return products }
        let products = try await with(errorHandler) {
            try await self.database.child("products").value.decodeArray(of: Product.self)
        }
        
        if isProductsObserved { return products }
        isProductsObserved = true
        database.child("products").observe(.value) { [weak self] snapshot in
            do {
                self?.products = try snapshot.value.decodeArray(of: Product.self)
            } catch {}
        }
        return products
    }
}

// MARK: - CartItemsAPI

struct CartItemWrapper: Codable { let productID, amount: Int }

extension RemoteRepositoryImpl: CartItemsAPI {
    
    func saveCartItems(_ cartItems: [CartItem], for user: User) async throws {
        try await with(errorHandler) {
            let array = cartItems.map { CartItemWrapper(productID: $0.product.variations[0].productID, amount: $0.amount) }
            try await database.child("carts").child(user.id).setValue(array.asFIRArray)
        }
    }
    
    func fetchCartItems(for user: User) async throws -> [(productID: Int, amount: Int)] {
        guard cartItems.isEmpty else { return cartItems }
        let cartItems = try await with(errorHandler) {
            try await database.child("carts").child(user.id).value
                .decodeArray(of: CartItemWrapper.self)
                .map { (productID: $0.productID, amount: $0.amount) }
        }
        
        if isCartItemsObserved { return cartItems }
        isCartItemsObserved = true
        database.child("carts").child(user.id).observe(.value) { [weak self] snapshot in
            do {
                self?.cartItems = try snapshot.value.decodeArray(of: CartItemWrapper.self)
                    .map { (productID: $0.productID, amount: $0.amount) }
            } catch {}
        }
        return cartItems
    }
}

// MARK: - FavoriteItemsAPI

extension RemoteRepositoryImpl: FavoriteItemsAPI {
    
    struct FavoriteItemWrapper: Codable { let modelID: ModelID }
    
    func saveFavoriteItems(_ items: [ModelID], for user: User) async throws {
        return try await with(errorHandler) {
            let array = items.map { FavoriteItemWrapper(modelID: $0) }
            print(items)
            try await database.child("favorites").child(user.id).setValue(array.asFIRArray)
        }
    }
    
    func fetchFavoriteItems(for user: User) async throws -> [ModelID] {
        guard favoriteItems.isEmpty else { return favoriteItems }
        let favoriteItems = try await with(errorHandler) {
            try await database.child("favorites").child(user.id).value
                .decodeArray(of: FavoriteItemWrapper.self)
                .map { $0.modelID }
        }
        
        if isFavoriteItemsObserved { return favoriteItems }
        isFavoriteItemsObserved = true
        database.child("favorites").child(user.id).observe(.value) { [weak self] snapshot in
            do {
                self?.favoriteItems = try snapshot.value.decodeArray(of: FavoriteItemWrapper.self)
                    .map { $0.modelID }
            } catch {}
        }
        return favoriteItems
    }
}

// MARK: - Private extension for helper methods

private extension RemoteRepositoryImpl {
    
    func errorHandler(_ error: Error) -> Error {
        return AppError.unknown(error)
    }
}

extension DatabaseReference {
    var value: Any? {
        get async {
            await withCheckedContinuation { continuation in
                self.observeSingleEvent(of: .value) { continuation.resume(returning: $0.value) }
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
            array["\(i)"] = item.asDictionary
        }
        return array
    }
}

extension Encodable {
    var asDictionary: [String: Any] {
        guard let jsonData = try? JSONEncoder().encode(self) else { return [:] }
        guard let dictionary = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else { return [:] }
        return dictionary
    }
}
