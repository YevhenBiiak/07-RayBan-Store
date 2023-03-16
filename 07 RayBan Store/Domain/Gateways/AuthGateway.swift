//
//  AuthGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

protocol AuthGateway {
    func login(email: String, password: String) async throws -> Profile
    func register(firstName: String, lastName: String, email: String, password: String) async throws -> Profile
    func forgotPassword(email: String) async throws
    func updateEmail(with email: String, for user: User, accountPassword: String) async throws
    func updatePassword(with newPassword: String, for user: User, accountPassword: String) async throws
    func loginWithFacebook() async throws -> Profile
    func logout() throws
}
