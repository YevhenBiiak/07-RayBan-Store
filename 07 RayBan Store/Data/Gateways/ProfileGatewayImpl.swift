//
//  ProfileGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

protocol ProfilesAPI {
    func saveProfile(_ profile: ProfileDTO) async throws
    func fetchProfile(for user: User) async throws -> ProfileDTO
}

class ProfileGatewayImpl {
    
    private let profilesAPI: ProfilesAPI
    
    init(profilesAPI: ProfilesAPI) {
        self.profilesAPI = profilesAPI
    }
}

extension ProfileGatewayImpl: ProfileGateway {
    
    func fetchProfile(for user: User) async throws -> ProfileDTO {
        try await profilesAPI.fetchProfile(for: user)
        // profile image can be uploaded here if it exists
    }
    
    func saveProfile(_ profile: ProfileDTO) async throws {
        try await profilesAPI.saveProfile(profile)
    }
}
