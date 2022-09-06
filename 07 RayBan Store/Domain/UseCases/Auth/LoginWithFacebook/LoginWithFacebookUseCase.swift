//
//  LoginWithFacebookUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 02.09.2022.
//

import Foundation

protocol LoginWithFacebookUseCase {
    func execute(completionHandler: @escaping (Result<Bool>) -> Void)
}

class LoginWithFacebookUseCaseImpl: LoginWithFacebookUseCase {
    
    private let authGateway: AuthGateway
    private let profileGateway: ProfileGateway

    init(authGateway: AuthGateway, profileGateway: ProfileGateway) {
        self.authGateway = authGateway
        self.profileGateway = profileGateway
    }
    
    func execute(completionHandler: @escaping (Result<Bool>) -> Void) {
        authGateway.loginWithFacebook { result in
            switch result {
            case .success(let profileDTO):
                do {
                    try self.profileGateway.saveProfile(profileDTO)
                    completionHandler(.success(true))
                } catch {
                    completionHandler(.failure(error))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
