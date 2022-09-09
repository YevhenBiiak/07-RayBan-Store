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
        let userId = Session.shared.userId
        
        profileGateway.fetchProfile(byUserId: userId) { [weak self] result in
            switch result {
            case .success(var profileDTO):
                self?.updateProfile(&profileDTO, withUpdateProfileRequest: request)
                
                self?.profileGateway.saveProfile(profileDTO, forUserId: userId) { result in
                    switch result {
                    case .success:
                        completionHandler(.success(true))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
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
