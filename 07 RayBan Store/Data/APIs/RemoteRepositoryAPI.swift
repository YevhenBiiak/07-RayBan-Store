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
}

// MARK: - ProfilesAPI

extension RemoteRepositoryImpl: ProfilesAPI {
    
    func fetchProfile(for user: User) async throws -> Profile {
        try await with(errorHandler) {
            let value = await database.child("customers").child(user.id).value
            let data = try JSONSerialization.data(withJSONObject: value as Any)
            return try JSONDecoder().decode(Profile.self, from: data)
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
        try await with(errorHandler) {
            let value = await self.database.child("products").value
            let data = try JSONSerialization.data(withJSONObject: value as Any)
            return try JSONDecoder().decode([Product].self, from: data)
        }
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

extension Encodable {
    var asDictionary: [String: Any] {
        guard let jsonData = try? JSONEncoder().encode(self) else { return [:] }
        guard let dictionary = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else { return [:] }
        return dictionary
    }
}
