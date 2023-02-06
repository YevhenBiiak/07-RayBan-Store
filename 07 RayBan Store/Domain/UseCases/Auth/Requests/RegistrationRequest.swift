//
//  RegistrationRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 02.09.2022.
//

import Foundation

struct RegistrationParameters {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
}

struct RegistrationRequest {
    let registrationParameters: RegistrationParameters
    let conformPassword: String
    let acceptedPolicy: Bool
}
