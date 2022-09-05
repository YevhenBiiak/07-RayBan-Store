//
//  AuthGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import Foundation

protocol AuthProvider {
    func login(email: String, password: String, completionHandler: @escaping (Result<Profile>) -> Void)
    func register(email: String, password: String, completionHandler: @escaping (Result<Profile>) -> Void)
    func loginWithFacebook(completionHandler: @escaping (Result<Profile>) -> Void)
    func forgotPassword(email: String, completionHandler: @escaping (Result<Bool>) -> Void)
}

protocol AuthLocalStorage {
    var isUserAuthenticated: Bool { get }
    func createUserProfile(_ user: Profile)
    func deleteUserProfile()
}

class AuthGatewayImpl: AuthGateway {
    
    private let authProvider: AuthProvider
    private let authLocalStorage: AuthLocalStorage
    
    init(authProvider: AuthProvider, authLocalStorage: AuthLocalStorage) {
        self.authProvider = authProvider
        self.authLocalStorage = authLocalStorage
    }
    
    // MARK: - AuthGateway protocol
    
    var isUserAuthenticated: Bool {
        authLocalStorage.isUserAuthenticated
    }
    
    func login(email: String, password: String, completionHandler: @escaping (Result<ProfileDTO>) -> Void) {
        
    }
    
    func register(email: String, password: String, completionHandler: @escaping (Result<ProfileDTO>) -> Void) {
        
    }
    
    func loginWithFacebook(completionHandler: @escaping (Result<ProfileDTO>) -> Void) {
        
    }
    
    func forgotPassword(email: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        
    }
    
    func logout() throws {
        
    }
}

/* MARK: - Firebase
 
if Auth.auth().currentUser != nil {
    // ...
}

Auth.auth().signIn(withEmail: email, password: password) { authResult, error in }

Auth.auth().createUser(withEmail: email, password: password) { authResult, error in }
 
let credential = OAuthProvider.credential(withProviderID: "facebook.com", idToken: idTokenString!, rawNonce: nonce)
Auth.auth().signIn(with: credential) { authResult, error in }

Auth.auth().sendPasswordReset(withEmail: email) { error in }
 
Auth.auth().currentUser?.updateEmail(to: email) { error in }
 
Auth.auth().currentUser?.updatePassword(to: password) { error in }

do {
    try Auth.auth().signOut()
} catch {
    print(error)
}
 
*/
