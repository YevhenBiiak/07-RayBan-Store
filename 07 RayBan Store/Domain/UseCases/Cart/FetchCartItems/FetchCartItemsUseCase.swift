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
    
    private let profileGateway: ProfileGateway
    private let cartItemsGateway: CartItemsGateway

    init(profileGateway: ProfileGateway, cartItemsGateway: CartItemsGateway) {
        self.profileGateway = profileGateway
        self.cartItemsGateway = cartItemsGateway
    }
    
    func execute(completionHandler: @escaping (Result<FetchCartItemsResponse>) -> Void) {
        do {
            let profileId = try profileGateway.getProfile().id
            cartItemsGateway.fetchCartItems(byCustomerId: profileId) { result in
                switch result {
                case .success(let cartItemsDTO):
                    
                    let cart = Cart(items: cartItemsDTO.asCartItems)
                    let fetchCartItemsResponse = FetchCartItemsResponse(cartItems: cart.items.asCartItemsDTO)
                    
                    completionHandler(.success(fetchCartItemsResponse))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
}
