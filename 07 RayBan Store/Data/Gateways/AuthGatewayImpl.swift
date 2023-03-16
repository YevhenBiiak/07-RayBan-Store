//
//  AuthGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.08.2022.
//

import Foundation

class AuthGatewayImpl {
    
    let profileGateway: ProfileGateway
    
    init(profileGateway: ProfileGateway) {
        self.profileGateway = profileGateway
    }
}

extension AuthGatewayImpl: AuthGateway {
    
    func login(email: String, password: String) async throws -> Profile {
        let user = try await AuthProvider.login(email: email, password: password)
        return try await profileGateway.fetchProfile(for: user)
    }
    
    func register(firstName: String, lastName: String, email: String, password: String) async throws -> Profile {
        let user = try await AuthProvider.register(email: email, password: password)
        let profile = Profile(id: user.id, firstName: firstName, lastName: lastName, email: email)
        try await profileGateway.saveProfile(profile)
        return profile
    }
    
    func forgotPassword(email: String) async throws {
        try await AuthProvider.forgotPassword(email: email)
    }
    
    func updateEmail(with email: String, for user: User, accountPassword: String) async throws {
        try await AuthProvider.updateEmail(with: email, password: accountPassword)
        var profile = try await profileGateway.fetchProfile(for: user)
        profile.email = email
        try await profileGateway.saveProfile(profile)
    }
    
    func updatePassword(with newPassword: String, for user: User, accountPassword: String) async throws {
        try await AuthProvider.updatePassword(with: newPassword, accountPassword: accountPassword)
    }
    
    func loginWithFacebook() async throws -> Profile {
        let profile = try await AuthProvider.loginWithFacebook()
        try await profileGateway.saveProfile(profile)
        return profile
    }
    
    func logout() throws {
        try AuthProvider.logout()
    }
}
