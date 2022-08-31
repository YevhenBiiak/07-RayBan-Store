//
//  User.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

struct User {
    let id: String
    let firstName: String
    let lastName: String?
    let email: String
    let shippingAddress: String?
    
    func fullName() -> String {
        "\(firstName) \(lastName ?? "")"
    }
}

struct NewUser {
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let shippingAddress: String
}
