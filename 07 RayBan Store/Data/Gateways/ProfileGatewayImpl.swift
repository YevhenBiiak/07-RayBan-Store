//
//  ProfileGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

class ProfileGatewayImpl {
    
    private let remoteRepository: RemoteRepository
    
    init(remoteRepository: RemoteRepository) {
        self.remoteRepository = remoteRepository
    }
}

extension ProfileGatewayImpl: ProfileGateway {
    
    func fetchProfile(byUserId userId: String) async throws -> ProfileDTO {
        try await remoteRepository.execute(.fetchProfile(id: userId, type: ProfileDTO.self))
    }
    
    func saveProfile(_ profile: ProfileDTO) async throws {
        try await remoteRepository.execute(.saveProfile(profile))
    }
}
