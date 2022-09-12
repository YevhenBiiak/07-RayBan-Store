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
    
    func fetchProfile(byUserId userId: UserId, completionHandler: @escaping (Result<ProfileDTO>) -> Void) {
        remoteRepository.executeFetchRequest(ofType: .profile(id: userId)) { (result: Result<ProfileDTO>) in
            completionHandler(result)
        }
    }
    
    func saveProfile(_ profile: ProfileDTO, forUserId userId: UserId, completionHandler: @escaping (Result<Bool>) -> Void) {
        remoteRepository.executeSaveRequest(ofType: .saveProfile(profile, userId: userId)) { result in
            completionHandler(result)
        }
    }
}
