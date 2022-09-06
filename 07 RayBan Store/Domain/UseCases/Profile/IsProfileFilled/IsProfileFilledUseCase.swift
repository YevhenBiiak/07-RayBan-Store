//
//  IsProfileFilledUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

protocol IsProfileFilledUseCase {
    func execute(completionHandler: @escaping (Result<Bool>) -> Void)
}

class IsProfileFilledUseCaseImpl: IsProfileFilledUseCase {
    
    private let profileGateway: ProfileGateway
    
    init(profileGateway: ProfileGateway) {
        self.profileGateway = profileGateway
    }
    
    func execute(completionHandler: @escaping (Result<Bool>) -> Void) {
        do {
            let profileDTO = try profileGateway.getProfile()
            completionHandler(.success(profileDTO.asProfile.isProfileFilled))
        } catch {
            completionHandler(.failure(error))
        }
    }
}
