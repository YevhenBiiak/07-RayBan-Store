//
//  UpdateProfileUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

protocol UpdateProfileUseCase {
    func execute(_ request: UpdateProfileRequest, completionHandler: @escaping (Result<Bool>) -> Void) 
}

class UpdateProfileUseCaseImpl: UpdateProfileUseCase {
    
    private let profileGateway: ProfileGateway
    
    init(profileGateway: ProfileGateway) {
        self.profileGateway = profileGateway
    }
    
    func execute(_ request: UpdateProfileRequest, completionHandler: @escaping (Result<Bool>) -> Void) {
        do {
            var profileDTO = try profileGateway.getProfile()
            updateProfile(&profileDTO, withUpdateProfileRequest: request)
            
            try profileGateway.saveProfile(profileDTO)
            
            completionHandler(.success(true))
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    private func updateProfile(_ profile: inout ProfileDTO, withUpdateProfileRequest request: UpdateProfileRequest) {
        if let firstName = request.firstName {
            profile.firstName = firstName
        }
        if let lastName = request.lastName {
            profile.lastName = lastName
        }
        if let address = request.address {
            profile.address = address
        }
    }
}
