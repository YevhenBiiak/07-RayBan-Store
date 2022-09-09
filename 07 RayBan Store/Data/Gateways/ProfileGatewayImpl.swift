//
//  ProfileGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

protocol ProfileRemoteRepository {
    func fetchProfile(byUserId userId: UserId, completionHandler: @escaping (Result<ProfileDTO>) -> Void)
    func saveProfile(_ profile: ProfileDTO, forUserId userId: UserId, completionHandler: @escaping (Result<Bool>) -> Void)
}

class ProfileGatewayImpl: ProfileGateway {
    
    private let profileRemoteRepository: ProfileRemoteRepository
    
    init(profileRemoteRepository: ProfileRemoteRepository) {
        self.profileRemoteRepository = profileRemoteRepository
    }
    
    func fetchProfile(byUserId userId: UserId, completionHandler: @escaping (Result<ProfileDTO>) -> Void) {
        profileRemoteRepository.fetchProfile(byUserId: userId, completionHandler: completionHandler)
    }
    
    func saveProfile(_ profile: ProfileDTO, forUserId userId: UserId, completionHandler: @escaping (Result<Bool>) -> Void) {
        profileRemoteRepository.saveProfile(profile, forUserId: userId, completionHandler: completionHandler)
    }
}
