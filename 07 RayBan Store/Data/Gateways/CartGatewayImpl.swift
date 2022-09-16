//
//  CartGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

class CartGatewayImpl: CartGateway {
    
    private let remoteRepository: RemoteRepository
    
    init(remoteRepository: RemoteRepository) {
        self.remoteRepository = remoteRepository
    }

    func fetchCartItems(byUserId userId: String, completionHandler: @escaping (Result<[CartItemDTO]>) -> Void) {
        remoteRepository.executeFetchRequest(ofType: .cartItems(userId: userId)) { (result: Result<[CartItemDTO]>) in
            switch result {
            case .success(let cartItems):
                completionHandler(.success(cartItems))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func saveCartItems(_ items: [CartItemDTO], forUserId userId: String, completionHandler: @escaping (Result<[CartItemDTO]>) -> Void) {
        remoteRepository.executeSaveRequest(ofType: .cartItems(items, userId: userId)) { (result: Result<Bool>) in
            switch result {
            case .success:
                completionHandler(.success(items))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
