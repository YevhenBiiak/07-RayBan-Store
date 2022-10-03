//
//  UICollectionReusableView +.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 21.09.2022.
//

import UIKit

extension UICollectionReusableView {
    static var reuseId: String {
        String(describing: self)
    }
}
