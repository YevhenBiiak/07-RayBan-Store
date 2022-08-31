//
//  AuthGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

protocol AuthGateway {
    var isUserAuthenticated: Bool { get }
    
    func login(email: String, password: String, completionHandler: @escaping (Result<Bool>) -> Void)
    func register(newUser: NewUser, completionHandler: @escaping (Result<Bool>) -> Void)
    func loginWithFacebook(completionHandler: @escaping (Result<Bool>) -> Void)
    func forgotPassword(email: String, completionHandler: @escaping (Result<Bool>) -> Void)
    func logout()
}
