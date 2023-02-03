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
    
    func login(email: String, password: String) async throws -> User {
        try await AuthProvider.login(email: email, password: password)
    }
    
    func register(firstName: String, lastName: String, email: String, password: String) async throws -> User {
        let user = try await AuthProvider.register(email: email, password: password)
        let profile = ProfileDTO(id: user.id, firstName: firstName, lastName: lastName, email: email)
        try await profileGateway.saveProfile(profile)
        return user
    }
    
    func loginWithFacebook() async throws -> User {
        let profile = try await AuthProvider.loginWithFacebook()
        try await profileGateway.saveProfile(profile)
        return User(id: profile.id)
    }
    
    func forgotPassword(email: String) async throws {
        try await AuthProvider.forgotPassword(email: email)
    }
    
    func logout() throws {
        try AuthProvider.logout()
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
