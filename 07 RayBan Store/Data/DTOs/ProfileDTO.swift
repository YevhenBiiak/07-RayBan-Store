//
//  ProfileDTO.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

struct ProfileDTO: Codable {
    let id: String
    var firstName: String? // nil when just registered
    var lastName: String?  // nil when just registered
    let email: String
    var address: String?   // nil when just registered
}

// Data mapping
extension ProfileDTO {
    var asProfile: Profile {
        Profile(
            id: self.id,
            firstName: self.firstName,
            lastName: self.lastName,
            email: self.email,
            address: self.address)
    }
}
