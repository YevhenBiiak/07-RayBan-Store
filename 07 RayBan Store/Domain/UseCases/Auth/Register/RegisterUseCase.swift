//
//  RegisterUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 02.09.2022.
//

import Foundation

class RegisterUseCase: UseCase<RegisterRequest, Bool, Never> {
    
    private let authGateway: AuthGateway
    private let profileGateway: ProfileGateway

    init(authGateway: AuthGateway, profileGateway: ProfileGateway) {
        self.authGateway = authGateway
        self.profileGateway = profileGateway
    }
    
    override func execute(_ request: RegisterRequest, completionHandler: @escaping (Result<Bool>) -> Void) {
        let email = request.email
        let password = request.password
        
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
