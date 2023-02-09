//
//  AuthGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

protocol AuthGateway {
    func login(email: String, password: String) async throws -> User
    func register(firstName: String, lastName: String, email: String, password: String) async throws -> User
    func loginWithFacebook() async throws -> User
    func forgotPassword(email: String) async throws
    func logout() throws
}
