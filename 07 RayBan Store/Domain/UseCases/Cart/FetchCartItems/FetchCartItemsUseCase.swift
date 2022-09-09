//
//  FetchCartItemsUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

protocol FetchCartItemsUseCase {
    func execute(completionHandler: @escaping (Result<FetchCartItemsResponse>) -> Void)
}

class FetchCartItemsUseCaseImpl: FetchCartItemsUseCase {
    
    private let cartItemsGateway: CartItemsGateway

    init(cartItemsGateway: CartItemsGateway) {
        self.cartItemsGateway = cartItemsGateway
    }
    
    func execute(completionHandler: @escaping (Result<FetchCartItemsResponse>) -> Void) {
        let userId = Session.shared.userId
        
        cartItemsGateway.fetchCartItems(byCustomerId: userId) { result in
            switch result {
            case .success(let cartItemsDTO):
                
                let cart = Cart(items: cartItemsDTO.asCartItems)
                let fetchCartItemsResponse = FetchCartItemsResponse(cartItems: cart.items.asCartItemsDTO)
                
                completionHandler(.success(fetchCartItemsResponse))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
