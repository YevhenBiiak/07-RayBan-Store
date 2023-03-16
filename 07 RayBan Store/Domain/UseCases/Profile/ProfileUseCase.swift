//
//  ProfileUseCase.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 09.03.2023.
//

protocol ProfileUseCase {
    func execute(_ request: IsProfileFilledRequest) async throws -> Bool
    func execute(_ request: GetProfileRequest) async throws -> Profile
    func execute(_ request: SaveProfileRequest) async throws
}

class ProfileUseCaseImpl {
    
    private let profileGateway: ProfileGateway
    
    init(profileGateway: ProfileGateway) {
        self.profileGateway = profileGateway
    }
}

extension ProfileUseCaseImpl: ProfileUseCase {
    
    func execute(_ request: IsProfileFilledRequest) async throws -> Bool {
        let profile = try await profileGateway.fetchProfile(for: request.user)
        return profile.isProfileFilled
    }
    
    func execute(_ request: GetProfileRequest) async throws -> Profile {
        try await profileGateway.fetchProfile(for: request.user)
    }
    
    func execute(_ request: SaveProfileRequest) async throws {
        try Validator.validateFirstName(request.profile.firstName)
        try Validator.validateLastName(request.profile.lastName)
        try Validator.validateEmail(request.profile.email)
        try Validator.validatePhone(request.profile.phone)
        try Validator.validateAddress(request.profile.address)
        
        try await profileGateway.saveProfile(request.profile)
    }
}
