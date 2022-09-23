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
        print(request)
        var dbQuery = database.child(request.path).queryEqual(toValue: request.queryValue, childKey: request.queryKey)
        
        if let limit = request.limit {
            dbQuery = dbQuery.queryLimited(toFirst: limit)
        }
        
        dbQuery.getData { error, snapshot in
            if let error = error { return completionHandler(.failure(error)) }
            guard let jsonObjc = snapshot?.value else { return }
            print(jsonObjc)
            do {
                let data = try JSONSerialization.data(withJSONObject: jsonObjc)
//                print(data)
                let entity = try JSONDecoder().decode(T.self, from: data)
//                print(T.self)
//                print(entity)
                completionHandler(.success(entity))
            } catch {
                completionHandler(.failure(error))
            }
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

struct Prod: Decodable {
    let category: String
    let description: String
    let id: Int
    let price: Int
    let title: String
}
