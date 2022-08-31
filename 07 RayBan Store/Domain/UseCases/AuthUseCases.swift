//
//  AuthUseCases.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

protocol AuthUseCases {
    var isUserAuthenticated: Bool { get }
    func login(email: String, password: String, completionHandler: @escaping (Result<Bool>) -> Void)
    func register(newUser: NewUser, completionHandler: @escaping (Result<Bool>) -> Void)
    func loginWithFacebook(completionHandler: @escaping (Result<Bool>) -> Void)
    func forgotPassword(email: String, completionHandler: @escaping (Result<Bool>) -> Void)
    func logout()
}

class AuthUseCasesImpl: AuthUseCases {
    
    private let authGateway: AuthGateway
    
    init(authGateway: AuthGateway) {
        self.authGateway = authGateway
    }
    
    // MARK: - AuthUseCases protocol
    
    var isUserAuthenticated: Bool {
        authGateway.isUserAuthenticated
    }
    
    func login(email: String, password: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        authGateway.login(email: email, password: password) { result in
            completionHandler(result)
        }
    }
    
    func register(newUser: NewUser, completionHandler: @escaping (Result<Bool>) -> Void) {
        authGateway.register(newUser: newUser) { result in
            completionHandler(result)
        }
    }
    
    func loginWithFacebook(completionHandler: @escaping (Result<Bool>) -> Void) {
        authGateway.loginWithFacebook { result in
            completionHandler(result)
        }
    }
    
    func forgotPassword(email: String, completionHandler: @escaping (Result<Bool>) -> Void) {
        authGateway.forgotPassword(email: email) { result in
            completionHandler(result)
        }
    }
    
    func logout() {
        authGateway.logout()
    }
}
