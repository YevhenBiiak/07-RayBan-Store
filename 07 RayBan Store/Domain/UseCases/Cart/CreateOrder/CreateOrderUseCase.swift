//
//  CreateOrderUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

protocol CreateOrderUseCase {
    func execute(_ request: CreateOrderRequest, completionHandler: @escaping (Result<CreateOrderResponse>) -> Void)
}

class CreateOrderUseCaseImpl: CreateOrderUseCase {
    
    private let profileGateway: ProfileGateway
    private let cartItemsGateway: CartItemsGateway
    private let orderGateway: OrderGateway

    init(profileGateway: ProfileGateway, cartItemsGateway: CartItemsGateway, orderGateway: OrderGateway) {
        self.profileGateway = profileGateway
        self.cartItemsGateway = cartItemsGateway
        self.orderGateway = orderGateway
    }
    
    func execute(_ request: CreateOrderRequest, completionHandler: @escaping (Result<CreateOrderResponse>) -> Void) {
        do {
            let profileId = try profileGateway.getProfile().id
            cartItemsGateway.fetchCartItems(byCustomerId: profileId) { [weak self] result in
                switch result {
                case .success(let cartItemsDTO):
                    
                    let cart = Cart(items: cartItemsDTO.asCartItems)
                    let order = cart.createOrder(customerId: profileId, shippindAddress: request.shippingAddress, shippingMethods: request.shippingMethods)
                    
                    self?.orderGateway.saveOrder(order.asOrderDTO, forCustomerId: profileId) { result in
                        switch result {
                        case .success(let orderDTO):
                            let createOrderResponse = CreateOrderResponse(order: orderDTO)
                            
                            completionHandler(.success(createOrderResponse))
                        case .failure(let error):
                            completionHandler(.failure(error))
                        }
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
}
