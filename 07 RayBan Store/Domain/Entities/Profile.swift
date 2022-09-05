//
//  Profile.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 28.08.2022.
//

import Foundation

struct Profile {
    let id: String
    let firstName: String?
    let lastName: String?
    let email: String
    let address: String?
    
    var isProfileFilled: Bool {
        firstName != nil && lastName != nil && address != nil
    }
}
