//
//  ProfileCodable.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 13.03.2023.
//

import Foundation

struct ProfileCodable: Codable {
    let id: String
    let firstName: String?
    let lastName: String?
    let email: String
    let phone: String?
    let address: String?
}

extension ProfileCodable {
    init(_ model: Profile) {
        self.id = model.id
        self.firstName = model.firstName
        self.lastName = model.lastName
        self.email = model.email
        self.phone = model.phone
        self.address = model.address
    }
}

extension Profile {
    init(_ model: ProfileCodable) {
        self.id = model.id
        self.firstName = model.firstName
        self.lastName = model.lastName
        self.email = model.email
        self.phone = model.phone
        self.address = model.address
    }
}
