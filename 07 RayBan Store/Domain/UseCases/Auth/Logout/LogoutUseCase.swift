//
//  LogoutUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 02.09.2022.
//

import Foundation

class LogoutUseCase: UseCase<Never, Never, Never> {
    
    private let authGateway: AuthGateway
    
    init(authGateway: AuthGateway) {
        self.authGateway = authGateway
    }
    
    override func execute() {
        try? authGateway.logout()
    }
}
