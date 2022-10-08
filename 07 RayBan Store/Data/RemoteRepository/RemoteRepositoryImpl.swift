//
//  RemoteRepositoryImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation
import FirebaseDatabase

class RemoteRepositoryImpl: RemoteRepository {
    
    private let database: DatabaseReference = Database.database().reference()
    
    func executeFetchRequest<T: Decodable>(ofType request: FetchRequest, completionHandler: @escaping (Result<T>) -> Void) {
        var dbQuery = database.child(request.path).queryEqual(toValue: request.queryValue)
        // print(request.path, request.queryKey, request.queryValue)
        if let queryKey = request.queryKey { dbQuery = dbQuery.queryOrdered(byChild: queryKey) }
    
        dbQuery.observeSingleEvent(of: .value) { snapshot in
            guard let snapshots = snapshot.children.allObjects as? [DataSnapshot],
                  var someType = snapshots.map({ $0.value }) as? Any
            else { return }
            
            // print(snapshots)
            // print(someType)
            
            // if "someType" is Dictionary -> get values
            if let dict = someType as? NSDictionary {
                someType = dict.allValues
            }
            
            // if generic type "T" is an Array -> do nothing
            if T.self is any Collection.Type {}
            // else if "T" isn't array and "someType" is an Array -> get first
            else if let array = someType as? NSArray {
                someType = array.firstObject ?? []
            }
            // print(someType)
            
            do {
                let data = try JSONSerialization.data(withJSONObject: someType)
                let entity = try JSONDecoder().decode(T.self, from: data)
                
                completionHandler(.success(entity))
            } catch {
                completionHandler(.failure(error))
            }
            
        } withCancel: { error in
            completionHandler(.failure(error))
        }
    }
    
    func executeSaveRequest(ofType request: SaveRequest, completionHandler: @escaping (Result<Bool>) -> Void) {
        database.child(request.path).child(request.key).setValue(request.value.asDictionary) { error, _ in
            if let error = error {
                return completionHandler(.failure(error))
            }
            
            completionHandler(.success(true))
        }
    }
}
