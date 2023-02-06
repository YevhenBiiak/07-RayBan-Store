//
//  AuthProvider.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation
import FirebaseAuth
import FBSDKLoginKit

struct User: Identifiable {
    let id: String
}

struct AuthProvider {
    
    static var currentUser: User? {
        guard let id = Auth.auth().currentUser?.uid else { return nil }
        return User(id: id)
    }
    
    static func login(email: String, password: String) async throws -> User {
        try await perform {
            let userId = try await Auth.auth().signIn(withEmail: email, password: password).user.uid
            return User(id: userId)
        }
    }
    
    static func register(email: String, password: String) async throws -> User {
        try await perform {
            let userId = try await Auth.auth().createUser(withEmail: email, password: password).user.uid
            return User(id: userId)
        }
    }
    
    static func forgotPassword(email: String) async throws {
        try await perform {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        }
    }
    
    static func logout() throws {
        try perform {
            try Auth.auth().signOut()
        }
    }
    
    static func loginWithFacebook() async throws -> ProfileDTO {
        let (credential, firstName, lastName) = try await performFacebookRequest()
        return try await perform {
            let result = try await Auth.auth().signIn(with: credential)
            return ProfileDTO(id: result.user.uid, firstName: firstName, lastName: lastName, email: result.user.email!)
        }
    }
}

// MARK: - Private extension with helper methods
private extension AuthProvider {
    
    /// this method can throw AuthProviderError only
    @MainActor
    static func performFacebookRequest() async throws -> (credential: AuthCredential, firstName: String?, lastName: String?) {
        try await withCheckedThrowingContinuation { continuation in
            LoginManager().logIn(permissions: [], from: nil) { result, error in
                guard result?.isCancelled == false else { return continuation.resume(throwing: AuthProviderError.facebookLoginWasCancelled) }

                if let error = error { return continuation.resume(throwing: AuthProviderError.facebookError(error)) }

                let token = result?.token?.tokenString
                let request = GraphRequest(
                    graphPath: "me",
                    parameters: ["fields": "email, first_name, last_name"],
                    tokenString: token,
                    version: nil,
                    httpMethod: .get)

                request.start { _, response, error in
                    if let error { return continuation.resume(throwing: AuthProviderError.facebookError(error)) }

                    let userInfo = response as? [String: String]
                    let firstName = userInfo?["first_name"]
                    let lastName = userInfo?["last_name"]

                    let credential: AuthCredential = FacebookAuthProvider.credential(withAccessToken: token!)
                    continuation.resume(returning: (credential, firstName, lastName))
                }
            }
        }
    }
    
    static func perform<T>(_ code: () async throws -> T) async throws -> T {
        do    { return try await code() }
        catch { throw handledError(error) }
    }
    
    static func perform<T>(_ code: () throws -> T) throws -> T {
        do    { return try code() }
        catch { throw handledError(error) }
    }
    
    /// handle FIRAuthErros only and throws AuthProviderError
    static func handledError(_ error: Error) -> Error {
        if let errorCode = AuthErrorCode.Code(rawValue: error._code) {
            switch errorCode {
            // case .operationNotAllowed:
                
            // signIn with Email and Password
            case .wrongPassword: return AuthProviderError.wrongPassword(error)
            case .invalidEmail:  return AuthProviderError.invalidEmail(error)
            case .userNotFound:  return AuthProviderError.userNotFound(error)
                
            // createUser with Email and Password
            case .emailAlreadyInUse: return AuthProviderError.emailAlreadyInUse(error)
            case .weakPassword:      return AuthProviderError.weakPassword(error)
                
            // sendPassword reset
            case .invalidSender:         return AuthProviderError.invalidEmail(error)
            case .invalidRecipientEmail: return AuthProviderError.invalidEmail(error)
            default: return AuthProviderError.unknown(error)
            }
        }
        fatalError("Unhandled error type: \(String(describing: error)) \(error.localizedDescription)")
    }
}

enum AuthProviderError: LocalizedError {
    case wrongPassword(Error)
    case invalidEmail(Error)
    case userNotFound(Error)
    case emailAlreadyInUse(Error)
    case weakPassword(Error)
    case facebookError(Error)
    case unknown(Error)
    case facebookLoginWasCancelled
    
    var errorDescription: String? {
        switch self {
        case .wrongPassword    (let error): return error.localizedDescription
        case .invalidEmail     (let error): return error.localizedDescription
        case .userNotFound     (let error): return error.localizedDescription
        case .emailAlreadyInUse(let error): return error.localizedDescription
        case .weakPassword     (let error): return error.localizedDescription
        case .facebookError    (let error): return error.localizedDescription
        case .unknown          (let error): return error.localizedDescription
        case .facebookLoginWasCancelled: return "The login with Facebook was cancelled by the user"
        }
    }
}
