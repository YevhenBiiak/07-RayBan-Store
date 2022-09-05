//
//  LoginUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 02.09.2022.
//

import Foundation

class LoginUseCase: UseCase<LoginRequest, Bool, Never> {
    
    private let profileGateway: ProfileGateway
    private let authGateway: AuthGateway

    init(authGateway: AuthGateway, profileGateway: ProfileGateway) {
        self.authGateway = authGateway
        self.profileGateway = profileGateway
    }
    
    override func execute(_ request: LoginRequest, completionHandler: @escaping (Result<Bool>) -> Void) {
        let email = request.email
        let password = request.password
        
        authGateway.login(email: email, password: password) { result in
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
