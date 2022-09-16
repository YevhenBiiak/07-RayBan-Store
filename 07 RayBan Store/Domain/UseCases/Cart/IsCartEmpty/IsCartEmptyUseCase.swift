//
//  IsCartEmptyUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

protocol IsCartEmptyUseCase {
    func execute(completionHandler: @escaping (Result<Bool>) -> Void)
}

class IsCartEmptyUseCaseImpl: IsCartEmptyUseCase {
    
    private let cartItemsGateway: CartGateway

    init(cartItemsGateway: CartGateway) {
        self.cartItemsGateway = cartItemsGateway
    }
    
    func execute(completionHandler: @escaping (Result<Bool>) -> Void) {
        let userId = Session.shared.userId
        
        cartItemsGateway.fetchCartItems(byUserId: userId) { result in
            switch result {
            case .success(let cartItemsDTO):
                let cart = Cart(items: cartItemsDTO.asCartItems)
                completionHandler(.success(cart.isCartEmpty))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
