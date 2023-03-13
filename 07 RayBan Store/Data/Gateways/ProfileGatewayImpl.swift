//
//  ProfileGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

protocol ProfilesAPI {
    func saveProfile(_ profile: ProfileCodable) async throws
    func fetchProfile(for user: User) async throws -> ProfileCodable
}

class ProfileGatewayImpl {
    
    private let profilesAPI: ProfilesAPI
    
    init(profilesAPI: ProfilesAPI) {
        self.profilesAPI = profilesAPI
    }
}

extension ProfileGatewayImpl: ProfileGateway {
    
    func fetchProfile(for user: User) async throws -> Profile {
        let profileCodable = try await profilesAPI.fetchProfile(for: user)
        // profile image can be uploaded here if it exists
        return Profile(profileCodable)
    }
    
    func saveProfile(_ profile: Profile) async throws {
        let profileCodable = ProfileCodable(profile)
        try await profilesAPI.saveProfile(profileCodable)
    }
}
