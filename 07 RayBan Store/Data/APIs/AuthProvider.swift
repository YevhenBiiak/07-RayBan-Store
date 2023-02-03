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
        let userId = try await Auth.auth().signIn(withEmail: email, password: password).user.uid
        return User(id: userId)
    }
    
    static func register(email: String, password: String) async throws -> User {
        let userId = try await Auth.auth().createUser(withEmail: email, password: password).user.uid
        return User(id: userId)
    }
    
    @MainActor
    static func loginWithFacebook() async throws -> ProfileDTO {
        try await withCheckedThrowingContinuation { continuation in
            let loginManager = LoginManager()
            loginManager.logIn(permissions: [], from: nil) { result, error in
                handleFBLoginResult(result, error: error, continuation: continuation)
            }
        }
    }
    
    static func forgotPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    static func logout() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - Private methods
    
    private static func handleFBLoginResult(_ result: LoginManagerLoginResult?, error: Error?, continuation: CheckedContinuation<ProfileDTO, Error>) {
        guard result?.isCancelled == false else { return }
        
        if let error = error {
            return continuation.resume(throwing: error)
        }
        
        let token = result?.token?.tokenString
        let request = GraphRequest(
            graphPath: "me",
            parameters: ["fields": "email, first_name, last_name"],
            tokenString: token,
            version: nil,
            httpMethod: .get)
        
        request.start { _, response, error in
            if let error { return continuation.resume(throwing: error) }
            
            let userInfo = response as? [String: String]
            let firstName = userInfo?["first_name"]
            let lastName = userInfo?["last_name"]
            
            let credential: AuthCredential = FacebookAuthProvider.credential(withAccessToken: token!)
            Auth.auth().signIn(with: credential) { result, error in
                if let error { return continuation.resume(throwing: error) }
                
                guard let id = result?.user.uid,
                      let email = result?.user.email
                else { return }
                
                let profile = ProfileDTO(id: id, firstName: firstName, lastName: lastName, email: email)
                return continuation.resume(returning: profile)
            }
        }
    }
}
