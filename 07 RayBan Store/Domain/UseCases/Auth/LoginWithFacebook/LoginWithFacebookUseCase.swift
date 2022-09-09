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

    init(authGateway: AuthGateway) {
        self.authGateway = authGateway
    }
    
    func execute(completionHandler: @escaping (Result<Bool>) -> Void) {
        authGateway.loginWithFacebook { result in
            switch result {
            case .success(let userId):
                Session.shared.userId = userId
                completionHandler(.success(true))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
