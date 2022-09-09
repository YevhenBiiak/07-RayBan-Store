//
//  ProfileGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

// The Profile is stored in local storage, created after authorization or registration, sent to the server when an order is created
protocol ProfileGateway {
    func fetchProfile(byUserId userId: UserId, completionHandler: @escaping (Result<ProfileDTO>) -> Void)
    func saveProfile(_ profile: ProfileDTO, forUserId userId: UserId, completionHandler: @escaping (Result<Bool>) -> Void)
}
