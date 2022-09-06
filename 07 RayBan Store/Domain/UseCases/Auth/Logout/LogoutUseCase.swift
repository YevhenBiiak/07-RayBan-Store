//
//  LogoutUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 02.09.2022.
//

import Foundation

protocol LogoutUseCase {
    func execute()
}

class LogoutUseCaseImpl: LogoutUseCase {
    
    private let authGateway: AuthGateway
    
    init(authGateway: AuthGateway) {
        self.authGateway = authGateway
    }
    
    func execute() {
        try? authGateway.logout()
    }
}
