//
//  IsUserAuthenticatedUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

protocol IsUserAuthenticatedUseCase {
    func execute() -> Bool
}

class IsUserAuthenticatedUseCaseImpl: IsUserAuthenticatedUseCase {
    
    private let authGateway: AuthGateway

    init(authGateway: AuthGateway) {
        self.authGateway = authGateway
    }
    
    func execute() -> Bool {
        guard let userId = authGateway.getUserId() else { return false }
        Session.shared.userId = userId
        return true
    }
}
