//
//  AuthProvider.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation
// import firabaseSDK
// import fbSDK

enum AppError: Error {
    case custom(String)
}

class AuthProviderImpl: AuthProvider {
    // let FirabaseAuthSDK
    // let FaceBookAuthSDK
    private var user: Profile?
    
    private let apiProfile: ApiProfile
    
    init(apiProfile: ApiProfile) {
        self.apiProfile = apiProfile
    }
    
    // MARK: - AuthProvider protocol
    
    func login(email: String, password: String, completionHandler: @escaping (Result<Profile>) -> Void) {
        guard let user = user else {
            return completionHandler(.failure(AppError.custom("users DB is empty")))
        }
        if user.email == email {
            completionHandler(.success(user))
        } else {
            completionHandler(.failure(AppError.custom("email is not exist")))
        }
    }
    
    func register(email: String, password: String, completionHandler: @escaping (Result<Profile>) -> Void) {
        guard user?.email == email else {
            return completionHandler(.failure(AppError.custom("user with this email is exist")))
        }
        
        let user = Profile(
            id: UUID().uuidString,
            firstName: nil,
            lastName: nil,
            email: email,
            address: nil)
        
        completionHandler(.success(user))
        self.user = user
    }
    
    func loginWithFacebook(completionHandler: @escaping (Result<Profile>) -> Void) {
        let user = Profile(
            id: UUID().uuidString,
            firstName: "FBName",
            lastName: nil,
            email: "fbname@mail.com",
            address: nil)
        
        completionHandler(.success(user))
        self.user = user
    }
    
    func forgotPassword(email: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        // firebase.forgotPassword(email)
        completionHandler(.success(true))
    }
    
}
