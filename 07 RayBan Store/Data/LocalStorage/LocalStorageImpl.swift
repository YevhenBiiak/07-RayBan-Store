//
//  LocalStorage.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

class LocalStorageImpl: ProfileLocalStorage {
    
    private var profile: User?
    
    // MARK: - ProfileLocalStorage
    
    var isUserAuthenticated: Bool {
        profile != nil
    }
    
    func saveUserProfile(_ user: User) {
        profile = user
    }
    
    func deleteUserProfile() {
        profile = nil
    }
}
