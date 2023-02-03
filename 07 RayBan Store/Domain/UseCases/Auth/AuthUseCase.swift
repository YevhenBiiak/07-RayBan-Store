//
//  LoginUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 02.09.2022.
//

import Foundation

protocol AuthUseCase {
    func execute(_ request: LoginRequest) async throws -> User
    func execute(_ request: RegistrationRequest) async throws -> User
    func execute(_ request: ForgotPasswordRequest) async throws
    func executeLoginWithFacebookRequest() async throws -> User
    func executeLogoutRequest() throws
}

class AuthUseCaseImpl: AuthUseCase {
    
    private let authGateway: AuthGateway

    init(authGateway: AuthGateway) {
        self.authGateway = authGateway
    }
    
    func execute(_ request: LoginRequest) async throws -> User {
        let email = request.email
        let password = request.password
        
        try Validator.validateEmail(email)
        try Validator.validatePassword(password)
        
        return try await authGateway.login(email: email, password: password)
    }
    
    func execute(_ request: RegistrationRequest) async throws -> User {
        let email = request.email
        let password = request.password
        let firstName = request.firstName
        let lastName = request.lastName
        
        try Validator.validateEmail(email)
        try Validator.validatePassword(password)
 
        return try await authGateway.register(firstName: firstName, lastName: lastName, email: email, password: password)
    }
    
    func execute(_ request: ForgotPasswordRequest) async throws {
        let email = request.email
        try Validator.validateEmail(email)
        try await authGateway.forgotPassword(email: email)
    }
    
    func executeLoginWithFacebookRequest() async throws -> User {
        try await authGateway.loginWithFacebook()
    }
    
    func executeLogoutRequest() throws {
        try authGateway.logout()
    }
}
