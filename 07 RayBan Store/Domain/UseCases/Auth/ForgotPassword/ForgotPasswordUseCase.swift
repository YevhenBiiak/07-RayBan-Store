//
//  ForgotPasswordUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 02.09.2022.
//

import Foundation

protocol ForgotPasswordUseCase {
    func execute(_ request: ForgotPasswordRequest, completionHandler: @escaping (Result<Bool>) -> Void)
}

class ForgotPasswordUseCaseImpl: ForgotPasswordUseCase {
    
    private let authGateway: AuthGateway
    
    init(authGateway: AuthGateway) {
        self.authGateway = gateway
    }
    
    func execute(_ request: ForgotPasswordRequest, completionHandler: @escaping (Result<Bool>) -> Void) {
        let email = request.email
        
        do {
            try Validator.validateEmail(email)
        } catch let error {
            return completionHandler(.failure(error))
        }
 
        authGateway.forgotPassword(email: email) { result in
            completionHandler(result)
        }
    }
}
