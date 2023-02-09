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
        try await with(errorHandler) {
            let userId = try await Auth.auth().signIn(withEmail: email, password: password).user.uid
            return User(id: userId)
        }
    }
    
    static func register(email: String, password: String) async throws -> User {
        try await with(errorHandler) {
            let userId = try await Auth.auth().createUser(withEmail: email, password: password).user.uid
            return User(id: userId)
        }
    }
    
    static func forgotPassword(email: String) async throws {
        try await with(errorHandler) {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        }
    }
    
    static func logout() throws {
        try with(errorHandler) {
            try Auth.auth().signOut()
        }
    }
    
    static func loginWithFacebook() async throws -> ProfileDTO {
        return try await with(errorHandler) {
            let (credential, firstName, lastName) = try await performFacebookRequest()
            let authResult = try await Auth.auth().signIn(with: credential)
            let (uid, email) = try parse(authResult)
            return ProfileDTO(id: uid, firstName: firstName, lastName: lastName, email: email)
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
                guard result?.isCancelled == false else { return continuation.resume(throwing: AppError.fbLoginWasCancelled) }

                if let error = error { return continuation.resume(throwing: AppError.facebookError(error.localizedDescription)) }

                let token = result?.token?.tokenString
                let request = GraphRequest(
                    graphPath: "me",
                    parameters: ["fields": "email, first_name, last_name"],
                    tokenString: token,
                    version: nil,
                    httpMethod: .get)

                request.start { _, response, error in
                    if let error { return continuation.resume(throwing: AppError.facebookError(error.localizedDescription)) }

                    let userInfo = response as? [String: String]
                    let firstName = userInfo?["first_name"]
                    let lastName = userInfo?["last_name"]

                    let credential = FacebookAuthProvider.credential(withAccessToken: token!)
                    continuation.resume(returning: (credential, firstName, lastName))
                }
            }
        }
    }
    
    static func parse(_ result: AuthDataResult) throws -> (uid: String, email: String) {
        guard let email = result.user.providerData.first(where: { $0.email?.isEmpty == false })?.email else {
            throw AppError.facebookError("Your facebook account does not have associated email addresses or you denied access to your email address. You can create account using email and password")
        }
        return (result.user.uid, email)
    }
    
    /// handles FIRAuthErros and returns an AppError
    static func errorHandler(_ error: Error) -> Error {
        if error is AppError {
            return error
        } else if let errorCode = AuthErrorCode.Code(rawValue: error._code) {
            print(error.localizedDescription)
            switch errorCode {
            // case .invalidMessagePayload - Indicates an invalid email template for sending update email.
                
            // signIn with Email and Password
            case .operationNotAllowed:   return AppError.operationNotAllowed
            case .wrongPassword:         return AppError.wrongPassword
            case .invalidEmail:          return AppError.invalidEmail
            case .userNotFound:          return AppError.userNotFound
                
            // createUser with Email and Password
            case .emailAlreadyInUse:     return AppError.emailAlreadyInUse
            case .weakPassword:          return AppError.weakPassword
                
            // sendPassword reset
            case .invalidSender:         return AppError.invalidSender
            case .invalidRecipientEmail: return AppError.invalidRecipientEmail
                
            case .networkError:          return AppError.networkError
                
            default:                     return AppError.unknown(error) }
            
        }
        
        fatalError("Unhandled error type: \(String(describing: error)) \(error.localizedDescription)")
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
