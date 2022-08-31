//
//  ProfileGateway.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

protocol ProfileGateway {
    func update(profile: User, completionHandler: @escaping (Result<Bool>) -> Void)
}
