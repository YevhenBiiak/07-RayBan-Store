//
//  AuthProvider.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation
import FirebaseAuth
import FBSDKLoginKit

class AuthProviderImpl: AuthProvider {
    
    // MARK: - AuthProvider protocol
    
    func getUserId() -> String? {
        Auth.auth().currentUser?.uid
    }
    
    func login(email: String, password: String, completionHandler: @escaping (Result<UserId>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            self?.handleFIRLoginResult(result, error: error, completion: completionHandler)
        }
    }
    
    func register(email: String, password: String, completionHandler: @escaping (Result<ProfileDTO>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            self?.handelFIRRegisterResult(result, error: error, completion: completionHandler)
        }
    }
    
    func loginWithFacebook(completionHandler: @escaping (Result<ProfileDTO>) -> Void) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [], from: nil) { [weak self] result, error in
            self?.handleFBLoginResult(result, error: error, completion: completionHandler)
        }
    }
    
    func forgotPassword(email: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                return completionHandler(.failure(error))
            }
            completionHandler(.success(true))
        }
    }
    
    func logout() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - Private methods
    
    private func handleFIRLoginResult(_ result: AuthDataResult?, error: Error?, completion: @escaping (Result<UserId>) -> Void) {
        if let error = error {
            return completion(.failure(error))
        }
        
        if let userId = result?.user.uid {
            completion(.success(userId))
        }
    }
    
    private func handelFIRRegisterResult(_ result: AuthDataResult?, error: Error?, completion: @escaping (Result<ProfileDTO>) -> Void) {
        if let error = error {
            return completion(.failure(error))
        }
        
        guard let id = result?.user.uid,
              let email = result?.user.email
        else { return }
        
        let profile = ProfileDTO(
            id: id,
            firstName: nil,
            lastName: nil,
            email: email,
            address: nil)
        
        completion(.success(profile))
    }
    
    private func handleFBLoginResult(_ result: LoginManagerLoginResult?, error: Error?, completion: @escaping (Result<ProfileDTO>) -> Void) {
        if let error = error {
            return completion(.failure(error))
        }
        
        let token = result?.token?.tokenString
        let request = GraphRequest(
            graphPath: "me",
            parameters: ["fields": "email, first_name, last_name"],
            tokenString: token,
            version: nil,
            httpMethod: .get)
        
        request.start { _, result, error in
            
            if let error = error {
                return completion(.failure(error))
            }
            
//            print(result)
            
            let credential: AuthCredential = FacebookAuthProvider.credential(withAccessToken: token!)
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    return completion(.failure(error))
                }
                
                guard let id = result?.user.uid,
                      let email = result?.user.email
                else { return }
                
                let profile = ProfileDTO(
                    id: id,
                    firstName: nil,
                    lastName: nil,
                    email: email,
                    address: nil)
                
                completion(.success(profile))
            }
        }
    }
}
