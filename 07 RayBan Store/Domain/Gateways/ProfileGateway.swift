//
//  ProfileGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

protocol ProfileGateway {
    func fetchProfile(byUserId userId: UserId, completionHandler: @escaping (Result<ProfileDTO>) -> Void)
    func saveProfile(_ profile: ProfileDTO, forUserId userId: UserId, completionHandler: @escaping (Result<Bool>) -> Void)
}
