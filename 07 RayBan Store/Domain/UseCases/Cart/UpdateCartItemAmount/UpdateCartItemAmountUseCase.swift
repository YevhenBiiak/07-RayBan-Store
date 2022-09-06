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
    
    private let profileGateway: ProfileGateway
    private let cartItemsGateway: CartItemsGateway

    init(profileGateway: ProfileGateway, cartItemsGateway: CartItemsGateway) {
        self.profileGateway = profileGateway
        self.cartItemsGateway = cartItemsGateway
    }
    
    func execute(_ request: UpdateCartItemAmountRequest, completionHandler: @escaping (Result<UpdateCartItemAmountResponse>) -> Void) {
        let productId = request.productId
        let amount = request.amount
        do {
            let profileId = try profileGateway.getProfile().id
            cartItemsGateway.fetchCartItems(byCustomerId: profileId) { [weak self] result in
                switch result {
                case .success(let cartItemsDTO):
                    
                    var cart = Cart(items: cartItemsDTO.asCartItems)
                    cart.update(productId: productId, amount: amount)
                    
                    self?.cartItemsGateway.saveCartItems(cart.items.asCartItemsDTO, forCustomerId: profileId) { result in
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
        } catch {
            completionHandler(.failure(error))
        }
    }
}
