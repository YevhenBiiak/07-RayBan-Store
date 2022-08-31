//
//  AuthProvider.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation
// import firabaseSDK
// import fbSDK

enum Custom: Error {
    case error(String)
}

class AuthProviderImpl: AuthProvider {
    
    // let firabaseSDK
    // let fbSDK
    
    private var user: User?
    
    func login(email: String, password: String, completionHandler: @escaping (Result<User>) -> Void) {
        guard let user = user else {
            return completionHandler(.failure(Custom.error("users DB is empty")))
        }
        if user.email == email {
            completionHandler(.success(user))
        } else {
            completionHandler(.failure(Custom.error("email is not exist")))
        }
    }
    
    func register(newUser: NewUser, completionHandler: @escaping (Result<User>) -> Void) {
        guard user?.email == newUser.email else {
            return completionHandler(.failure(Custom.error("user with this email is exist")))
        }
        
        let user = User(
            id: UUID().uuidString,
            firstName: newUser.firstName,
            lastName: newUser.lastName,
            email: newUser.email,
            shippingAddress: newUser.shippingAddress)
        
        completionHandler(.success(user))
        self.user = user
    }
    
    func loginWithFacebook(completionHandler: @escaping (Result<User>) -> Void) {
        let user = User(
            id: UUID().uuidString,
            firstName: "FBName",
            lastName: nil,
            email: "fbname@mail.com",
            shippingAddress: nil)
        
        completionHandler(.success(user))
        self.user = user
    }
    
    func forgotPassword(email: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        // firebase.forgotPassword(email)
        completionHandler(.success(true))
    }
    
}
