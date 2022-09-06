//
//  AddCartItemUseCase.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 03.09.2022.
//

import Foundation

protocol AddCartItemUseCase {
    func execute(_ request: AddCartItemRequest, completionHandler: @escaping (Result<AddCartItemResponse>) -> Void)
}

class AddCartItemUseCaseImpl: AddCartItemUseCase {
    
    private let profileGateway: ProfileGateway
    private let cartItemsGateway: CartItemsGateway

    init(profileGateway: ProfileGateway, cartItemsGateway: CartItemsGateway) {
        self.profileGateway = profileGateway
        self.cartItemsGateway = cartItemsGateway
    }
    
    func execute(_ request: AddCartItemRequest, completionHandler: @escaping (Result<AddCartItemResponse>) -> Void) {
        let product = request.productDTO.asProduct
        let amount = request.amount
        do {
            let profileId = try profileGateway.getProfile().id
            cartItemsGateway.fetchCartItems(byCustomerId: profileId) { [weak self] result in
                switch result {
                case .success(let cartItemsDTO):
                    
                    var cart = Cart(items: cartItemsDTO.asCartItems)
                    cart.add(product: product, amount: amount)
                    
                    self?.cartItemsGateway.saveCartItems(cart.items.asCartItemsDTO, forCustomerId: profileId) { result in
                        switch result {
                        case .success(let cartItemsDTO):
                            let addCartItemResponse = AddCartItemResponse(cartItems: cartItemsDTO)
                            
                            completionHandler(.success(addCartItemResponse))
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
