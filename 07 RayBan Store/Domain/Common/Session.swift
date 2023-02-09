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
    
    var userId: String = ""
    
}
