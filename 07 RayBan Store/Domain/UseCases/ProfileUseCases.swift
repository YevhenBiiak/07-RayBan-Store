//
//  ProfileUseCases.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

protocol ProfileUseCases {
    func update(profile: User, completionHandler: @escaping (Result<Bool>) -> Void)
}

class ProfileUseCasesImpl: ProfileUseCases {
    
    private let profileGateway: ProfileGateway
    
    init(profileGateway: ProfileGateway) {
        self.profileGateway = profileGateway
    }
    
    func update(profile: User, completionHandler: @escaping (Result<Bool>) -> Void) {
        profileGateway.update(profile: profile) { result in
            completionHandler(result)
        }
    }
    
}
