//
//  ProfileDTO.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

struct ProfileDTO: Codable {
    let id: String
    var firstName: String?
    var lastName: String?
    let email: String
    var address: String?
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

extension ProfileDTO: DictionaryConvertible {
    var asDictionary: [String: Any] {
        var dictionary = [String: Any]()
        
        dictionary["id"] = id
        dictionary["email"] = email
        dictionary["firstName"] = firstName
        dictionary["lastName"] = lastName
        dictionary["address"] = address
        
        return dictionary
    }
}
