//
//  UINavigationBar +.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import UIKit

extension UINavigationBar {
    func addLogoImage(_ image: UIImage) {
        let aspectRatio = image.size.width / image.size.height
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: frame.width * 0.025,
                                 y: 0,
                                 width: 44 * aspectRatio,
                                 height: 44)
        addSubview(imageView)
    }
}
