//
//  UpdateProfileRequest.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

struct UpdateProfileRequest: RequestModel {
    let firstName: String?
    let lastName: String?
    let address: String?
}
