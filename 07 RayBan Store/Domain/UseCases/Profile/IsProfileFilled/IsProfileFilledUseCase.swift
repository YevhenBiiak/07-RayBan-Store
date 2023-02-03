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
//        let userId = Session.shared.userId
//        profileGateway.fetchProfile(byUserId: userId) { result in
//            switch result {
//            case .success(let profileDTO):
//                completionHandler(.success(profileDTO.asProfile.isProfileFilled))
//            case .failure(let error):
//                completionHandler(.failure(error))
//            }
//        }
    }
}
