//
//  UINavigationItem +.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import UIKit

extension UINavigationItem {
    func addLogoImage(_ image: UIImage) {
        let aspectRatio = image.size.width / image.size.height
        
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        imageView.widthAnchor.constraint(equalToConstant: 44 * aspectRatio).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        leftBarButtonItem = UIBarButtonItem(customView: imageView)
    }
}
