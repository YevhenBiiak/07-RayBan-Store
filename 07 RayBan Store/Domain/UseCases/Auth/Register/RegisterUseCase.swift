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
    private let profileGateway: ProfileGateway

    init(authGateway: AuthGateway, profileGateway: ProfileGateway) {
        self.authGateway = authGateway
        self.profileGateway = profileGateway
    }
    
    func execute(_ request: RegisterRequest, completionHandler: @escaping (Result<Bool>) -> Void) {
        let email = request.email
        let password = request.password
        
        do {
            try Validator.validateEmail(email)
            try Validator.validatePassword(password)
        } catch let error {
            completionHandler(.failure(error))
        }
 
        authGateway.register(email: email, password: password) { result in
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
