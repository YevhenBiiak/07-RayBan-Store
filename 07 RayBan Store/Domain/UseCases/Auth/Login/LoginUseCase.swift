//
//  LoginUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 02.09.2022.
//

import Foundation

protocol LoginUseCase {
    func execute(_ request: LoginRequest, completionHandler: @escaping (Result<Bool>) -> Void)
}

class LoginUseCaseImpl: LoginUseCase {
    
    private let authGateway: AuthGateway

    init(authGateway: AuthGateway) {
        self.authGateway = authGateway
    }
    
    func execute(_ request: LoginRequest, completionHandler: @escaping (Result<Bool>) -> Void) {
        let email = request.email
        let password = request.password
        
        do {
            try Validator.validateEmail(email)
            try Validator.validatePassword(password)
        } catch {
            return completionHandler(.failure(error))
        }
        
        authGateway.login(email: email, password: password) { result in
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
