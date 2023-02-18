//
//  LoginUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 02.09.2022.
//

import Foundation

protocol AuthUseCase {
    @discardableResult
    func execute(_ request: LoginRequest) async throws -> Profile
    @discardableResult
    func execute(_ request: RegistrationRequest) async throws -> Profile
    func execute(_ request: ForgotPasswordRequest) async throws
    @discardableResult
    func executeLoginWithFacebookRequest() async throws -> Profile
    func executeLogoutRequest() throws
}

class AuthUseCaseImpl {
    
    private let authGateway: AuthGateway
    
    init(authGateway: AuthGateway) {
        self.authGateway = authGateway
    }
}

extension AuthUseCaseImpl: AuthUseCase {
    
    func execute(_ request: LoginRequest) async throws -> Profile {
        let email = request.email
        let password = request.password
        
        try Validator.validateEmail(email)
        try Validator.validatePassword(password)
        
        return try await authGateway.login(email: email, password: password)
    }
    
    func execute(_ request: RegistrationRequest) async throws -> Profile {
        let firstName = request.registrationParameters.firstName
        let lastName = request.registrationParameters.lastName
        let email = request.registrationParameters.email
        let password = request.registrationParameters.password
        let conformPassrowd = request.registrationParameters.conformPassword
        let acceptedPolicy = request.registrationParameters.acceptedPolicy
        
        try Validator.validateFirstName(firstName)
        try Validator.validateLastName(lastName)
        try Validator.validateEmail(email)
        try Validator.validatePassword(password)
        try Validator.validatePasswordsMatch(password, and: conformPassrowd)
        try Validator.validatePolicyAcceptance(acceptedPolicy)
        
        return try await authGateway.register(firstName: firstName, lastName: lastName, email: email, password: password)
    }
    
    func execute(_ request: ForgotPasswordRequest) async throws {
        let email = request.email
        try Validator.validateEmail(email)
        try await authGateway.forgotPassword(email: email)
    }
    
    func executeLoginWithFacebookRequest() async throws -> Profile {
        try await authGateway.loginWithFacebook()
    }
    
    func executeLogoutRequest() throws {
        try authGateway.logout()
    }
}
