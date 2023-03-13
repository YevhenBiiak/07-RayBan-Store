//
//  Profile.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

struct User: Identifiable {
    let id: String
}

struct Profile {
    let id: String
    var firstName: String?
    var lastName: String?
    var email: String
    var phone: String?
    var address: String?
    
    var isProfileFilled: Bool {
        firstName != nil && lastName != nil && address != nil
    }
}

extension Profile: Codable {}
