//
//  AuthRequests.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 02.09.2022.
//

struct LoginRequest {
    let email: String
    let password: String
}

struct RegistrationParameters {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let conformPassword: String
    let acceptedPolicy: Bool
}

struct RegistrationRequest {
    let registrationParameters: RegistrationParameters
}

struct ForgotPasswordRequest {
    let email: String
}

struct UpdateEmailRequest {
    let user: User
    let newEmail: String
    let confirmEmail: String
    let password: String
}

struct UpdatePasswordRequest {
    let user: User
    let newPassword: String
    let confirmPassword: String
    let accountPassword: String
}
