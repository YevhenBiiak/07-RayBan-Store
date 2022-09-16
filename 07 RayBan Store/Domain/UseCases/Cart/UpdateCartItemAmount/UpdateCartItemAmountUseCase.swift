//
//  UpdateCartItemAmountUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

protocol UpdateCartItemAmountUseCase {
    func execute(_ request: UpdateCartItemAmountRequest, completionHandler: @escaping (Result<UpdateCartItemAmountResponse>) -> Void)
}

class UpdateCartItemAmountUseCaseImpl: UpdateCartItemAmountUseCase {
    
    private let cartItemsGateway: CartGateway

    init(cartItemsGateway: CartGateway) {
        self.cartItemsGateway = cartItemsGateway
    }
    
    func execute(_ request: UpdateCartItemAmountRequest, completionHandler: @escaping (Result<UpdateCartItemAmountResponse>) -> Void) {
        let productId = request.productId
        let amount = request.amount
        let userId = Session.shared.userId
        
        cartItemsGateway.fetchCartItems(byUserId: userId) { [weak self] result in
            switch result {
            case .success(let cartItemsDTO):
                
                var cart = Cart(items: cartItemsDTO.asCartItems)
                cart.update(productId: productId, amount: amount)
                
                self?.cartItemsGateway.saveCartItems(cart.items.asCartItemsDTO, forUserId: userId) { result in
                    switch result {
                    case .success(let cartItemsDTO):
                        let updateCartItemAmountResponse = UpdateCartItemAmountResponse(cartItems: cartItemsDTO)
                        
                        completionHandler(.success(updateCartItemAmountResponse))
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
