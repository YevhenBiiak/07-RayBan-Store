//
//  LocalStorage.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

class LocalStorageImpl {
    
    private var profile: Profile?
    private var cart: Cart?
    
}

// MARK: - ProfileLocalStorage

extension LocalStorageImpl: AuthLocalStorage {
    
    var isUserAuthenticated: Bool {
        profile != nil
    }
    
    func createUserProfile(_ user: Profile) {
        profile = user
    }
    
    func deleteUserProfile() {
        profile = nil
    }
}

// MARK: - ProfileLocalStorage
    
extension LocalStorageImpl: ProfileLocalStorage {
    
    func updateUserProfile(_ user: Profile) {
        profile = user
    }
}
