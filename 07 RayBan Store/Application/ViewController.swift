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
        
//        showBlockingAlert(title: "Error", message: "Blockint text text text text text text text text text text")
//        showAlert(title: "Simple Alert", message: "Simple Alert text text text text text text text text text text ", buttonTitle: "Accept") {
//            print("accept")
//        }
        showDialogAlert(title: "Dialog alert", message: "text text text text text text text text text text text", confirmTitle: "DELETE")
    }
}
