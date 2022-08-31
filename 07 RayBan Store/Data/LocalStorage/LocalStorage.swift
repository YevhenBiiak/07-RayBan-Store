//
//  LocalStorage.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

class LocalStorageImpl {
    
    private var profile: User?
    private var cart: Cart?
    
}

// MARK: - ProfileLocalStorage

extension LocalStorageImpl: AuthLocalStorage {
    
    var isUserAuthenticated: Bool {
        profile != nil
    }
    
    func createUserProfile(_ user: User) {
        profile = user
    }
    
}

// MARK: - ProfileLocalStorage
    
extension LocalStorageImpl: ProfileLocalStorage {
    
    var isProfileFilled: Bool {
        profile?.lastName != nil && profile?.shippingAddress != nil
    }
    
    func updateUserProfile(_ user: User) {
        profile = user
    }
    
    func deleteUserProfile() {
        profile = nil
    }
}

// MARK: - ProfileLocalStorage

extension LocalStorageImpl: CartLocalStorage {
    
    var isCartEmpty: Bool {
        cart != nil
    }
    
}
