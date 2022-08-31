//
//  ProfileGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

protocol ApiProfile {
    func update(profile: User, completionHandler: @escaping (Result<Bool>) -> Void)
}

protocol ProfileLocalStorage {
    var isProfileFilled: Bool { get }
    func updateUserProfile(_ user: User)
    func deleteUserProfile()
}

class ProfileGatewayImpl: ProfileGateway {
    private let apiProfile: ApiProfile
    private let profileLocalStorage: ProfileLocalStorage
    
    init(apiProfile: ApiProfile, profileLocalStorage: ProfileLocalStorage) {
        self.apiProfile = apiProfile
        self.profileLocalStorage = profileLocalStorage
    }
    
    func update(profile: User, completionHandler: @escaping (Result<Bool>) -> Void) {
        apiProfile.update(profile: profile) { [weak self] result in
            switch result {
            case .success(let flag):
                self?.profileLocalStorage.updateUserProfile(profile)
                completionHandler(.success(flag))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
