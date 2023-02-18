//
//  IndexPath + .swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 14.02.2023.
//

import Foundation

extension IndexPath {
    static func + (left: IndexPath, right: Int) -> IndexPath {
        IndexPath(item: left.item + right, section: left.section)
    }
}
