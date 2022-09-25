//
//  OrderGatewayImpl.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 16.09.2022.
//

import Foundation

class OrderGatewayImpl: OrderGateway {
    
    private let remoteRepository: RemoteRepository
    
    init(remoteRepository: RemoteRepository) {
        self.remoteRepository = remoteRepository
    }
    
    func fetchOrders(byUserId userId: String, first: Int, skip: Int, completionHandler: @escaping (Result<[OrderDTO]>) -> Void) {
        remoteRepository.executeFetchRequest(ofType: .orders(userId: userId, limit: UInt(first) + UInt(skip))) { (result: Result<[OrderDTO]>) in
            switch result {
            case .success(var orders):
                orders = Array(orders.dropFirst(skip).prefix(first))
                completionHandler(.success(orders))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func createOrder(_ order: OrderDTO, forUserId userId: String, completionHandler: @escaping (Result<OrderDTO>) -> Void) {
        remoteRepository.executeSaveRequest(ofType: .order(order, userId: userId)) { result in
            switch result {
            case .success:
                completionHandler(.success(order))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}
