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
    
    private let cartItemsGateway: CartItemsGateway
    private let orderGateway: OrderGateway

    init(cartItemsGateway: CartItemsGateway, orderGateway: OrderGateway) {
        self.cartItemsGateway = cartItemsGateway
        self.orderGateway = orderGateway
    }
    
    func execute(_ request: CreateOrderRequest, completionHandler: @escaping (Result<CreateOrderResponse>) -> Void) {
        let shippingAddress = request.shippingAddress
        let shippingMethods = request.shippingMethods
        let userId = Session.shared.userId
        
        cartItemsGateway.fetchCartItems(byCustomerId: userId) { [weak self] result in
            switch result {
            case .success(let cartItemsDTO):
                
                let cart = Cart(items: cartItemsDTO.asCartItems)
                let order = cart.createOrder(customerId: userId, shippindAddress: shippingAddress, shippingMethods: shippingMethods)
                
                self?.orderGateway.createOrder(order.asOrderDTO, forCustomerId: userId) { result in
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
    }
}
