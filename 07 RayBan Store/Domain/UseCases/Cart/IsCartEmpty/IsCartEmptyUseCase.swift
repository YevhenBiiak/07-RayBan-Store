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
    
    private let profileGateway: ProfileGateway
    private let cartItemsGateway: CartItemsGateway

    init(profileGateway: ProfileGateway, cartItemsGateway: CartItemsGateway) {
        self.profileGateway = profileGateway
        self.cartItemsGateway = cartItemsGateway
    }
    
    func execute(completionHandler: @escaping (Result<Bool>) -> Void) {
        do {
            let profileId = try profileGateway.getProfile().id
            cartItemsGateway.fetchCartItems(byCustomerId: profileId) { result in
                switch result {
                case .success(let cartItemsDTO):
                    let cart = Cart(items: cartItemsDTO.asCartItems)
                    completionHandler(.success(cart.isCartEmpty))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
}
