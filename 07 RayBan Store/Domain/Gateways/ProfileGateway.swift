//
//  ProfileGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

protocol ProfileGateway {
    func fetchProfile(for user: User) async throws -> ProfileDTO
    func saveProfile(_ profile: ProfileDTO) async throws
}
