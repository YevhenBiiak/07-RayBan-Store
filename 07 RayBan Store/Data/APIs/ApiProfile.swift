//
//  ApiProfile.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 01.09.2022.
//

import Foundation

class ApiProfileImpl: ApiProfile {
    
    // let FirabaseDatabaseSDK
    
    func update(profile: Profile, completionHandler: @escaping (Result<Bool>) -> Void) {
        // send update profile request to firebaseDB
        completionHandler(.success(true))
    }
    
}
