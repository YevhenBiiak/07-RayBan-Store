//
//  RegisterUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 02.09.2022.
//

import Foundation

protocol RegisterUseCase {
    func execute(_ request: RegisterRequest, completionHandler: @escaping (Result<Bool>) -> Void)
}

class RegisterUseCaseImpl: RegisterUseCase {
    
    private let authGateway: AuthGateway

    init(authGateway: AuthGateway) {
        self.authGateway = authGateway
    }
    
    func execute(_ request: RegisterRequest, completionHandler: @escaping (Result<Bool>) -> Void) {
        let email = request.email
        let password = request.password
        
        do {
            try Validator.validateEmail(email)
            try Validator.validatePassword(password)
        } catch {
            return completionHandler(.failure(error))
        }
 
        authGateway.register(email: email, password: password) { result in
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
