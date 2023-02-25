//
//  ProfileGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

protocol ProfileGateway {
    func fetchProfile(for user: User) async throws -> Profile
    func saveProfile(_ profile: Profile) async throws
}
