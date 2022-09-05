//
//  ProfileGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

protocol ApiProfile {
    func update(profile: Profile, completionHandler: @escaping (Result<Bool>) -> Void)
}

protocol ProfileLocalStorage {
    func updateUserProfile(_ user: Profile)
}

class ProfileGatewayImpl {//}: ProfileGateway {
    
    private let apiProfile: ApiProfile
    private let profileLocalStorage: ProfileLocalStorage
    
    init(apiProfile: ApiProfile, profileLocalStorage: ProfileLocalStorage) {
        self.apiProfile = apiProfile
        self.profileLocalStorage = profileLocalStorage
    }
    
}
