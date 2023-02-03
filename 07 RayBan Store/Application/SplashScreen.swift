//
//  SplashScreen.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 01.02.2023.
//

import UIKit
import Stevia

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Add Logo ImageView
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        
        // configure layout
        view.subviews(imageView)
        imageView.width(60%).centerInContainer()
    }
}
