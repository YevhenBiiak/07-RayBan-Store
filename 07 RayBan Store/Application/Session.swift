//
//  Session.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 09.09.2022.
//

import Foundation

class Session {
    
    static let shared = Session()
    
    private init() {}
    
    var user: User!
    
    lazy var productImagesAPI = ProductImagesApiImpl()
    
    lazy var remoteRepositoryAPI = RemoteRepositoryImpl()
    
}
