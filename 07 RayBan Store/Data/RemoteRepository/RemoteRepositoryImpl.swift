//
//  RemoteRepositoryImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation
import FirebaseDatabase

protocol RemoteRepository {
    func executeFetchRequest<T: Decodable>(ofType request: FetchRequest, completionHandler: @escaping (Result<T>) -> Void)
    func executeSaveRequest(ofType request: SaveRequest, completionHandler: @escaping (Result<Bool>) -> Void)
}

class RemoteRepositoryImpl: RemoteRepository {
    
    private let database: DatabaseReference = Database.database().reference()
    
    func executeFetchRequest<T: Decodable>(ofType request: FetchRequest, completionHandler: @escaping (Result<T>) -> Void) {
        var dbQuery = database.child(request.path).queryEqual(toValue: request.queryValue)
        
        if let queryKey = request.queryKey { dbQuery = dbQuery.queryOrdered(byChild: queryKey) }
        if let limit = request.limit { dbQuery = dbQuery.queryLimited(toFirst: limit) }
        
        dbQuery.observeSingleEvent(of: .value) { snapshot in
            guard var someType = snapshot.value else { return }
            
            // if someType is still Dictionary -> get values
            if let dict = someType as? NSDictionary {
                someType = dict.allValues
            }
            // if result type is Array -> do nothing
            if T.self is any Collection.Type {}
            // else if result isn't array and someType is an Array -> get last element
            else if let array = someType as? NSArray {
                someType = array.lastObject ?? []
            }
            
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
