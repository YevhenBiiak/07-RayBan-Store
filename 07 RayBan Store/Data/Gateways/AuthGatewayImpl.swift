//
//  AuthGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import Foundation

class AuthGatewayImpl {
    
    let profileGateway: ProfileGateway
    
    init(profileGateway: ProfileGateway) {
        self.profileGateway = profileGateway
    }
}

extension AuthGatewayImpl: AuthGateway {
    
    func login(email: String, password: String) async throws -> User {
        try await withHandler {
            try await AuthProvider.login(email: email, password: password)
        }
    }
    
    func register(firstName: String, lastName: String, email: String, password: String) async throws -> User {
        try await withHandler {
            let user = try await AuthProvider.register(email: email, password: password)
            let profile = ProfileDTO(id: user.id, firstName: firstName, lastName: lastName, email: email)
            try await profileGateway.saveProfile(profile)
            return user
        }
    }
    
    func loginWithFacebook() async throws -> User {
        try await withHandler {
            let profile = try await AuthProvider.loginWithFacebook()
            try await profileGateway.saveProfile(profile)
            return User(id: profile.id)
        }
    }
    
    func forgotPassword(email: String) async throws {
        try await withHandler {
            try await AuthProvider.forgotPassword(email: email)
        }
    }
    
    func logout() throws {
        try withHandler {
            try AuthProvider.logout()
        }
    }
}

// MARK: - Private extension for helper methods

private extension AuthGatewayImpl {
    
    func withHandler<T>(_ code: () async throws -> T) async throws -> T {
        do    { return try await code() }
        catch { throw handledError(error) }
    }
    
    func withHandler<T>(_ code: () throws -> T) throws -> T {
        do    { return try code() }
        catch { throw handledError(error) }
    }
    
    func handledError(_ error: Error) -> Error {
        // AuthProviderError
        if let error = error as? AuthProviderError {
            switch error {
            case .wrongPassword:     return AuthGatewayError.wrongPassword(error)
            case .invalidEmail:      return AuthGatewayError.invalidEmail(error)
            case .userNotFound:      return AuthGatewayError.userNotFound(error)
            case .emailAlreadyInUse: return AuthGatewayError.emailAlreadyInUse(error)
            case .weakPassword:      return AuthGatewayError.weakPassword(error)
            case .facebookError:     return AuthGatewayError.facebookError(error)
            case .facebookLoginWasCancelled: return AuthGatewayError.fbLoginWasCancelled(error)
            case .unknown:
                fatalError("Unknown Error from AuthProviderError" + String(describing: error) + error.localizedDescription)
            }
        // ProfileGatewayError
        } else if let error = error as? ProfileGatewayError {
            switch error {
                
            }
        }
        fatalError("Unhandled error type: \(String(describing: error)) \(error.localizedDescription)")
    }
}

enum AuthGatewayError: LocalizedError {
    // AuthProviderError
    case weakPassword(Error)
    case wrongPassword(Error)
    case invalidEmail(Error)
    case userNotFound(Error)
    case emailAlreadyInUse(Error)
    case facebookError(Error)
    case fbLoginWasCancelled(Error)
    // ProfileGatewayError
    
    var errorDescription: String? {
        switch self {
        case .weakPassword     (let error): return error.localizedDescription
        case .wrongPassword    (let error): return error.localizedDescription
        case .invalidEmail     (let error): return error.localizedDescription
        case .userNotFound     (let error): return error.localizedDescription
        case .emailAlreadyInUse(let error): return error.localizedDescription
        case .facebookError    (let error): return error.localizedDescription
        case .fbLoginWasCancelled(let error): return error.localizedDescription
        }
    }
}

/* MARK: - Firebase
 
Auth.auth().currentUser?.updateEmail(to: email) { error in }
 
Auth.auth().currentUser?.updatePassword(to: password) { error in }
 
MARK: Facebook
 
if let token = AccessToken.current, !token.isExpired {
    // some
}
 
*/
