//
//  AuthenticationUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

protocol AuthenticationUseCase {
    func login(email: String, password: String)
    func register(email: String, password: String)
    func loginWithFacebook()
    func forgotPassword()
    func logout()
}

class AuthenticationUseCaseImpl: AuthenticationUseCase {
    
    private let authGateway: AuthGateway
    
    init(authGateway: AuthGateway) {
        self.authGateway = authGateway
    }
    
    func login(email: String, password: String) {
        authGateway.login(email: email, password: password)
    }
    
    func register(email: String, password: String) {
        authGateway.register(email: email, password: password)
    }
    
    func loginWithFacebook() {
        authGateway.loginWithFacebook()
    }
    
    func forgotPassword() {
        authGateway.forgotPassword()
    }
    
    func logout() {
        authGateway.logout()
    }
}
