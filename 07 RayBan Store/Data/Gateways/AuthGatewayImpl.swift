//
//  AuthGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import Foundation
import FirebaseAuth
import FBSDKLoginKit

protocol AuthProvider {
    func getUserId() -> String?
    func login(email: String, password: String, completionHandler: @escaping (Result<UserId>) -> Void)
    func register(email: String, password: String, completionHandler: @escaping (Result<ProfileDTO>) -> Void)
    func loginWithFacebook(completionHandler: @escaping (Result<ProfileDTO>) -> Void)
    func forgotPassword(email: String, completionHandler: @escaping (Result<Bool>) -> Void)
    func logout() throws
}

protocol AuthLocalStorage {
    func createUserProfile(_ user: Profile)
    func deleteUserProfile()
}

class AuthGatewayImpl: AuthGateway {
    
    let authProvider: AuthProvider
    let profileGateway: ProfileGateway
    
    init(authProvider: AuthProvider, profileGateway: ProfileGateway) {
        self.authProvider = authProvider
        self.profileGateway = profileGateway
    }
    
    // MARK: - AuthGateway protocol
    
    func getUserId() -> String? {
        authProvider.getUserId()
    }
    
    func login(email: String, password: String, completionHandler: @escaping (Result<UserId>) -> Void) {
        authProvider.login(email: email, password: password) { result in
            completionHandler(result)
        }
    }
    
    func register(email: String, password: String, completionHandler: @escaping (Result<UserId>) -> Void) {
        authProvider.register(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let profileDTO):
                self?.profileGateway.saveProfile(profileDTO, forUserId: profileDTO.id) { result in
                    switch result {
                    case .success:
                        completionHandler(.success(profileDTO.id))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func loginWithFacebook(completionHandler: @escaping (Result<UserId>) -> Void) {
        authProvider.loginWithFacebook { [weak self] result in
            switch result {
            case .success(let profileDTO):
                self?.profileGateway.saveProfile(profileDTO, forUserId: profileDTO.id) { result in
                    switch result {
                    case .success:
                        completionHandler(.success(profileDTO.id))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func forgotPassword(email: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        authProvider.forgotPassword(email: email) { result in
            completionHandler(result)
        }
    }
    
    func logout() throws {
        try authProvider.logout()
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
