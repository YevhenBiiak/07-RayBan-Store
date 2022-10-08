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
        let path = "prod"
        let queryKey: String? = nil// "RB3698M SCUDERIA FERRARI COLLECTION"
        let queryValue: Any? = nil
        
        var dbQuery = db.child(path).queryEqual(toValue: queryValue)
        if let queryKey {
            dbQuery = dbQuery.queryOrdered(byChild: queryKey)
        }
        dbQuery.observeSingleEvent(of: .value) { snapshot in
            
            print(snapshot)
            guard let jsonObjc = snapshot.value else { return }
            print(jsonObjc)
            
        } withCancel: { error in
            print("ERROR:", error.localizedDescription)
        }
        
    }
    
    //        db.child("customers/a458ghpr9fhd").queryEqual(toValue: nil, childKey: "cart").getData { error, snapshot in
    //
    //            print(snapshot)
    //        }
    
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
