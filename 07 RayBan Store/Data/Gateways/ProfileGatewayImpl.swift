//
//  ProfileGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

class ProfileGatewayImpl: ProfileGateway {
    
    private let remoteRepository: RemoteRepository
    
    init(remoteRepository: RemoteRepository) {
        self.remoteRepository = remoteRepository
    }
    
    func fetchProfile(byUserId userId: UserId) async throws -> ProfileDTO {
        try await remoteRepository.execute(.fetchProfile(id: userId, type: ProfileDTO.self))
    }
    
    func saveProfile(_ profile: ProfileDTO) async throws {
        try await remoteRepository.execute(.saveProfile(profile))
    }
}
