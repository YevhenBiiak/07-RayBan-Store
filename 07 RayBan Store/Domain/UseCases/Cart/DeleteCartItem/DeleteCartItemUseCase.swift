//
//  DeleteCartItemUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

protocol DeleteCartItemUseCase {
    func execute(_ request: DeleteCartItemRequest, completionHandler: @escaping (Result<DeleteCartItemResponse>) -> Void)
}

class DeleteCartItemUseCaseImpl: DeleteCartItemUseCase {
    
    private let cartItemsGateway: CartItemsGateway

    init(cartItemsGateway: CartItemsGateway) {
        self.cartItemsGateway = cartItemsGateway
    }
    
    func execute(_ request: DeleteCartItemRequest, completionHandler: @escaping (Result<DeleteCartItemResponse>) -> Void) {
        let productId = request.productId
        let userId = Session.shared.userId
        
        cartItemsGateway.fetchCartItems(byCustomerId: userId) { [weak self] result in
            switch result {
            case .success(let cartItemsDTO):
                
                var cart = Cart(items: cartItemsDTO.asCartItems)
                cart.delete(productId: productId)
                
                self?.cartItemsGateway.saveCartItems(cart.items.asCartItemsDTO, forCustomerId: userId) { result in
                    switch result {
                    case .success(let cartItemsDTO):
                        let deleteCartItemResponse = DeleteCartItemResponse(cartItems: cartItemsDTO)
                        
                        completionHandler(.success(deleteCartItemResponse))
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
