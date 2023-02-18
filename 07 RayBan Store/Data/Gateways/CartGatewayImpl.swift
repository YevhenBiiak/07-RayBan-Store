//
//  CartGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 31.08.2022.
//

import Foundation

protocol CartAPI {
    
}

class CartGatewayImpl {
    
    private let remoteRepository: RemoteRepositoryAPI
    
    init(remoteRepository: RemoteRepositoryAPI) {
        self.remoteRepository = remoteRepository
    }
}
    
extension CartGatewayImpl: CartGateway {
    
    func fetchCartItems(for user: User, includeImages: Bool) async throws -> [CartItem] {
        []
    }
    
    func saveCartItems(_ items: [CartItem], for user: User) async throws {
        
    }
    
    func saveOrder(_ order: Order, for user: User) async throws {
        
    }
    
//    func fetchCartItems(byUserId userId: String, completionHandler: @escaping (Result<[CartItemDTO]>) -> Void) {
//        remoteRepository.executeFetchRequest(ofType: .cartItems(userId: userId)) { (result: Result<[CartItemDTO]>) in
//            switch result {
//            case .success(let cartItems):
//                completionHandler(.success(cartItems))
//            case .failure(let error):
//                completionHandler(.failure(error))
//            }
//        }
//    }
    
//    func saveCartItems(_ items: [CartItemDTO], forUserId userId: String, completionHandler: @escaping (Result<[CartItemDTO]>) -> Void) {
//        remoteRepository.executeSaveRequest(ofType: .cartItems(items, userId: userId)) { (result: Result<Bool>) in
//            switch result {
//            case .success:
//                completionHandler(.success(items))
//            case .failure(let error):
//                completionHandler(.failure(error))
//            }
//        }
//    }
}
