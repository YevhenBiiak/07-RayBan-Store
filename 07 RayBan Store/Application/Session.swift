//
//  Session.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 09.09.2022.
//

import Foundation

struct User: Identifiable {
    let id: String
}

class Session {
    
    static let shared = Session()
    
    private init() {}
    
    var user: User!
    
    lazy var remoteRepositoryAPI: RemoteRepositoryAPI = RemoteRepositoryImpl()
    
}
