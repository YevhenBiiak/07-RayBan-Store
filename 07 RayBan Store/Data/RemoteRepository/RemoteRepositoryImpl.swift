//
//  RemoteRepositoryImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation
import FirebaseDatabase

protocol RemoteRepository {
    func execute(_ request: SaveRequest) async throws
    func execute<T>(_ request: FetchRequest<T>) async throws -> T where T: Decodable
}

class RemoteRepositoryImpl: RemoteRepository {
 
    private let database: DatabaseReference = Database.database().reference()
    
    func execute(_ request: SaveRequest) async throws {
        try await database.child(request.path).child(request.key).updateChildValues(request.value.asDictionary)
    }
    
    func execute<T>(_ request: FetchRequest<T>) async throws -> T where T: Decodable {
        try await withCheckedThrowingContinuation { continuation in
            execute(request, completionHandler: continuation.resume)
        }
    }
    
    func execute<T: Decodable>(_ request: FetchRequest<T>, completionHandler: @escaping (Result<T>) -> Void) {
        var dbQuery = database.child(request.path).queryEqual(toValue: request.queryValue)
        // print(request.path, request.queryKey, request.queryValue)
        if let queryKey = request.queryKey { dbQuery = dbQuery.queryOrdered(byChild: queryKey) }
    
        dbQuery.observeSingleEvent(of: .value) { snapshot in
            DispatchQueue.global().async {
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
            }
        } withCancel: { error in
            completionHandler(.failure(error))
        }
    }
}
