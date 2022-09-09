//
//  AuthGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

typealias UserId = String

protocol AuthGateway {
    func getUserId() -> String?
    func login(email: String, password: String, completionHandler: @escaping (Result<UserId>) -> Void)
    func register(email: String, password: String, completionHandler: @escaping (Result<UserId>) -> Void)
    func loginWithFacebook(completionHandler: @escaping (Result<UserId>) -> Void)
    func forgotPassword(email: String, completionHandler: @escaping (Result<Bool>) -> Void)
    func logout() throws
}
