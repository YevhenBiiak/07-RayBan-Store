//
//  ViewController.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 11.08.2022.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appWhite
        let imageView = UIImageView(frame: CGRect(x: 0, y: 130, width: 300, height: 700))
        imageView.image = UIImage(named: "logo")
        view.addSubview(imageView)
        
        Task {
            do {
//                try await AuthProvider.login(email: "evgeniy.bijak@gmail.com", password: "12345678")
                
                try await AuthProvider.updatePassword(with: "123456", accountPassword: "12345678")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
