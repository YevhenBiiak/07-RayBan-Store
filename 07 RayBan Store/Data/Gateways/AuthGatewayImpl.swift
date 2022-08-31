//
//  AuthGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import Foundation

protocol AuthProvider {
    func login(email: String, password: String, completionHandler: @escaping (Result<User>) -> Void)
    func register(newUser: NewUser, completionHandler: @escaping (Result<User>) -> Void)
    func loginWithFacebook(completionHandler: @escaping (Result<User>) -> Void)
    func forgotPassword(email: String, completionHandler: @escaping (Result<Bool>) -> Void)
}

protocol AuthLocalStorage {
    var isUserAuthenticated: Bool { get }
    func createUserProfile(_ user: User)
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
    
    func login(email: String, password: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        authProvider.login(email: email, password: password) { [weak self] result in
            self?.handleAuthResult(result, completionHandler: completionHandler)
        }
    }
    
    func register(newUser: NewUser, completionHandler: @escaping (Result<Bool>) -> Void) {
        authProvider.register(newUser: newUser) { [weak self] result in
            self?.handleAuthResult(result, completionHandler: completionHandler)
        }
    }
    
    func loginWithFacebook(completionHandler: @escaping (Result<Bool>) -> Void) {
        authProvider.loginWithFacebook { [weak self] result in
            self?.handleAuthResult(result, completionHandler: completionHandler)
        }
    }
    
    func forgotPassword(email: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        authProvider.forgotPassword(email: email) { result in
            completionHandler(result)
        }
    }
    
    func logout() {
        authLocalStorage.deleteUserProfile()
    }
    
    // MARK: - Private methods
    
    private func handleAuthResult(_ result: Result<User>, completionHandler: @escaping (Result<Bool>) -> Void) {
        switch result {
        case .success(let user):
            authLocalStorage.createUserProfile(user)
            completionHandler(.success(true))
        case .failure(let error):
            completionHandler(.failure(error))
        }
    }
}
