//
//  AuthGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

protocol AuthGateway {
    func login(email: String, password: String) async throws -> ProfileDTO
    func register(firstName: String, lastName: String, email: String, password: String) async throws -> ProfileDTO
    func loginWithFacebook() async throws -> ProfileDTO
    func forgotPassword(email: String) async throws
    func logout() throws
}
