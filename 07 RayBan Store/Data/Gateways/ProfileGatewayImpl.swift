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
    
    func fetchProfile(byUserId userId: UserId) async throws -> ProfileDTO {
        try await perform {
            try await remoteRepository.execute(.fetchProfile(id: userId, type: ProfileDTO.self))
        }
    }
    
    func saveProfile(_ profile: ProfileDTO) async throws {
        try await perform {
            try await remoteRepository.execute(.saveProfile(profile))
        }
    }
}

// MARK: - Private extension for helper methods

private extension ProfileGatewayImpl {
    
    // Helper methods for rethrowing errors
    func perform<T>(_ code: () async throws -> T) async throws -> T {
        do    { return try await code() }
        catch { throw handledError(error) }
    }
    
    func handledError(_ error: Error) -> Error {
        if let error = error as? RemoteRepositoryError {
            switch error {
            case .unknown(let error):
                fatalError(error.localizedDescription)
            }
        }
        fatalError("Unhandled error type: \(String(describing: error)) \(error.localizedDescription)")
    }
}

enum ProfileGatewayError: LocalizedError {
    
}
