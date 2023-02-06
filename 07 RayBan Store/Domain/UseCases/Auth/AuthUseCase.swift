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

class AuthUseCaseImpl {
    
    private let authGateway: AuthGateway
    
    init(authGateway: AuthGateway) {
        self.authGateway = authGateway
    }
}

extension AuthUseCaseImpl: AuthUseCase {
    
    func execute(_ request: LoginRequest) async throws -> User {
        try await withHandler {
            let email = request.email
            let password = request.password

            try Validator.validateEmail(email)
            try Validator.validatePassword(password)
            return try await authGateway.login(email: email, password: password)
        }
    }
    
    func execute(_ request: RegistrationRequest) async throws -> User {
        try await withHandler {
            let email = request.email
            let password = request.password
            let firstName = request.firstName
            let lastName = request.lastName

            try Validator.validateEmail(email)
            try Validator.validatePassword(password)
            try Validator.validateFirstName(firstName)
            try Validator.validateLastName(lastName)

            return try await authGateway.register(firstName: firstName, lastName: lastName, email: email, password: password)
        }
    }
    
    func execute(_ request: ForgotPasswordRequest) async throws {
        try await withHandler {
            let email = request.email
            try Validator.validateEmail(email)
            try await authGateway.forgotPassword(email: email)
        }
    }
    
    func executeLoginWithFacebookRequest() async throws -> User {
        try await withHandler {
            try await authGateway.loginWithFacebook()
        }
    }
    
    func executeLogoutRequest() throws {
        try withHandler {
            try authGateway.logout()
        }
    }
}

// MARK: - Private extension for helper methods

private extension AuthUseCaseImpl {
    
    func withHandler<T>(_ code: () async throws -> T) async throws -> T {
        do    { return try await code() }
        catch { throw handledError(error) }
    }
    
    func withHandler<T>(_ code: () throws -> T) throws -> T {
        do    { return try code() }
        catch { throw handledError(error) }
    }
    
    func handledError(_ error: Error) -> Error {
        if let error = error as? ValidationError {
            switch error {
            case .emailFormatIsWrong:    return AuthUseCaseError.emailFormatIsWrong(error)
            case .emailValueIsEmpty:     return AuthUseCaseError.emailValueIsEmpty(error)
            case .firstNameValueIsEmpty: return AuthUseCaseError.firstNameValueIsEmpty(error)
            case .lastNameValueIsEmpty:  return AuthUseCaseError.lastNameValueIsEmpty(error)
            case .passwordValueIsEmpty:  return AuthUseCaseError.passwordValueIsEmpty(error)
            case .passwordLengthIsWrong: return AuthUseCaseError.passwordLengthIsWrong(error)
            }
        } else if let error = error as? AuthGatewayError {
            switch error {
            case .wrongPassword:     return AuthUseCaseError.wrongPassword(error)
            case .invalidEmail:      return AuthUseCaseError.invalidEmail(error)
            case .userNotFound:      return AuthUseCaseError.userNotFound(error)
            case .emailAlreadyInUse: return AuthUseCaseError.emailAlreadyInUse(error)
            case .weakPassword:      return AuthUseCaseError.weakPassword(error)
            case .facebookError:     return AuthUseCaseError.facebookError(error)
            case .fbLoginWasCancelled: return AuthUseCaseError.fbLoginWasCancelled
            }
        }
        fatalError("Unhandled error type: \(String(describing: error)) \(error.localizedDescription)")
    }
}

enum AuthUseCaseError: LocalizedError {
    // ValidationError
    case emailValueIsEmpty(Error)
    case passwordValueIsEmpty(Error)
    case firstNameValueIsEmpty(Error)
    case lastNameValueIsEmpty(Error)
    case emailFormatIsWrong(Error)
    case passwordLengthIsWrong(Error)
    // AuthGatewayError
    case weakPassword(Error)
    case wrongPassword(Error)
    case invalidEmail(Error)
    case userNotFound(Error)
    case emailAlreadyInUse(Error)
    case facebookError(Error)
    case fbLoginWasCancelled
    
    var errorDescription: String? {
        switch self {
        case .emailValueIsEmpty    (let error): return error.localizedDescription
        case .passwordValueIsEmpty (let error): return error.localizedDescription
        case .firstNameValueIsEmpty(let error): return error.localizedDescription
        case .lastNameValueIsEmpty (let error): return error.localizedDescription
        case .emailFormatIsWrong   (let error): return error.localizedDescription
        case .passwordLengthIsWrong(let error): return error.localizedDescription
        case .weakPassword         (let error): return error.localizedDescription
        case .wrongPassword        (let error): return error.localizedDescription
        case .invalidEmail         (let error): return error.localizedDescription
        case .userNotFound         (let error): return error.localizedDescription
        case .emailAlreadyInUse    (let error): return error.localizedDescription
        case .facebookError        (let error): return error.localizedDescription
        case .fbLoginWasCancelled: return "The facebook login was cancelled"
        }
    }
}
