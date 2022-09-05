//
//  ForgotPasswordUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 02.09.2022.
//

import Foundation

class ForgotPasswordUseCase: UseCase<ForgotPasswordRequest, Bool, Never> {
    
    private let authGateway: AuthGateway
    
    init(authGateway: AuthGateway) {
        self.authGateway = gateway
    }
    
    override func execute(_ request: ForgotPasswordRequest, completionHandler: @escaping (Result<Bool>) -> Void) {
        let email = request.email
        
        authGateway.forgotPassword(email: email) { result in
            completionHandler(result)
        }
    }
}
