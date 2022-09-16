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
        
        let db = Database.database().reference()
                
        db.child("customers/a458ghpr9fhd").queryEqual(toValue: nil, childKey: "cart").getData { error, snapshot in
            
            print(snapshot)
        }
        
//        firebaseDB.child("users").child(profile.id).setValue(profile.asDictionary)
//
//        firebaseDB.child("users").child(profile.id).child("cart").setValue(["2367345": ["amount": 1], "234555": ["amount": 2]])
//        
//        firebaseDB.child("users").child(profile.id).getData { error, data in
//            if let data = data {
//                print( data.value as? [String: Any] ?? "")
//                do {
//                    let data = try JSONSerialization.data(withJSONObject: data.value, options: [])
//                    let struc = try JSONDecoder().decode(ProfileDTO.self, from: data)
//                    print(struc)
//                } catch {
//
//                }
//            }
//        }
    }
}
