//
//  Date + .swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 11.03.2023.
//

import Foundation

extension Date {
    
    func formatted(_ format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}
