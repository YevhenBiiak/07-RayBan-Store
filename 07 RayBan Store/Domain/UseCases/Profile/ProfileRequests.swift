//
//  ProfileRequests.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 09.03.2023.
//

struct IsProfileFilledRequest {
    let user: User
}

struct GetProfileRequest {
    let user: User
}

struct SaveProfileRequest {
    let user: User
    let profile: Profile
}

struct UpdateProfileRequest {
    let firstName: String?
    let lastName: String?
    let address: String?
}
