//
//  ProfileRemoteRepositoryImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation
import FirebaseDatabase

class ProfileRemoteRepositoryImpl: ProfileRemoteRepository {
    
    private let profileDB = Database.database().reference().child("customers")
    
    func fetchProfile(byUserId userId: UserId, completionHandler: @escaping (Result<ProfileDTO>) -> Void) {
        profileDB.child(userId).getData { error, snapshot in
            if let error = error {
                return completionHandler(.failure(error))
            }
            
            guard let jsonObjc = snapshot?.value else { return }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonObjc, options: [])
                let profileDTO = try JSONDecoder().decode(ProfileDTO.self, from: data)
                
                completionHandler(.success(profileDTO))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }
    
    func saveProfile(_ profile: ProfileDTO, forUserId userId: UserId, completionHandler: @escaping (Result<Bool>) -> Void) {
        profileDB.child(userId).setValue(profile.asDictionary) { error, _ in
            if let error = error {
                return completionHandler(.failure(error))
            }
            
            completionHandler(.success(true))
        }
    }
}
