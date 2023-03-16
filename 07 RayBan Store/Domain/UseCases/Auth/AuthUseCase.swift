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
    func execute(_ request: UpdateEmailRequest) async throws
    func execute(_ request: UpdatePasswordRequest) async throws
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
        try Validator.validateEmail(request.email)
        try Validator.validatePassword(request.password)
        
        return try await authGateway.login(email: request.email, password: request.password)
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
        try Validator.checkValueMatching(password, and: conformPassrowd)
        try Validator.validatePolicyAcceptance(acceptedPolicy)
        
        return try await authGateway.register(firstName: firstName, lastName: lastName, email: email, password: password)
    }
    
    func execute(_ request: ForgotPasswordRequest) async throws {
        try Validator.validateEmail(request.email)
        try await authGateway.forgotPassword(email: request.email)
    }
    
    func execute(_ request: UpdateEmailRequest) async throws {
        try Validator.validateEmail(request.newEmail)
        try Validator.checkValueMatching(request.newEmail, and: request.confirmEmail)
        try Validator.validatePassword(request.password)
        
        try await authGateway.updateEmail(with: request.newEmail, for: request.user, accountPassword: request.password)
    }
    
    func execute(_ request: UpdatePasswordRequest) async throws {
        try Validator.validatePassword(request.newPassword)
        try Validator.checkValueMatching(request.newPassword, and: request.confirmPassword)
        try Validator.validatePassword(request.accountPassword)
        
        try await authGateway.updatePassword(with: request.newPassword, for: request.user, accountPassword: request.accountPassword)
    }
    
    func executeLoginWithFacebookRequest() async throws -> Profile {
        try await authGateway.loginWithFacebook()
    }
    
    func executeLogoutRequest() throws {
        try authGateway.logout()
    }
}
