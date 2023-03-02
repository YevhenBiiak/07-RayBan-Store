//
//  AccountMenuRouter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 29.09.2022.
//

class AccountMenuRouterImpl: Routable, AccountMenuRouter {
    
    weak var viewController: ListViewController!
    
    required init(viewController: ListViewController) {
        self.viewController = viewController
    }
    
    func presentShoppingCart() {
        let cartViewController = CartViewController()
        let cartConfigurator = CartConfiguratorImpl()
        
        cartViewController.configurator = cartConfigurator
        navigationController?.pushViewController(cartViewController, animated: true)
    }
    
    func presentPersonalDetails() {
        
    }
    
    func presentOrderHistory() {
        
    }
    
    func presentFavoriteList() {
        let favoritesViewController = FavoritesViewController()
        let favoritesConfigurator = FavoritesConfiguratorImpl()
        
        favoritesViewController.configurator = favoritesConfigurator
        navigationController?.pushViewController(favoritesViewController, animated: true)
    }
}
