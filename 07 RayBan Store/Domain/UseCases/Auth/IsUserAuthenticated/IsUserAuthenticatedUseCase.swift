//
//  IsUserAuthenticatedUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

class IsUserAuthenticatedUseCase: UseCase<Never, Never, Bool> {
    
    private let authGateway: AuthGateway

    init(authGateway: AuthGateway) {
        self.authGateway = authGateway
    }
    
    override func execute() -> Bool {
        authGateway.isUserAuthenticated
    }
}
