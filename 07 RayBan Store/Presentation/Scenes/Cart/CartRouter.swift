//
//  CartRouter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 25.02.2023.
//

class CartRouterImpl: Routable, CartRouter {
    
    weak var viewController: CartViewController!
    
    required init(viewController: CartViewController) {
        self.viewController = viewController
    }
    
    func presentCart() {
        
    }
}
