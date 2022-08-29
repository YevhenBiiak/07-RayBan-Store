//
//  AuthGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

protocol AuthGateway {
    func login(email: String, password: String)
    func register(email: String, password: String)
    func loginWithFacebook()
    func forgotPassword()
    func logout()
}
