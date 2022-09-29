//
//  AccountMenuPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 29.09.2022.
//

import Foundation

protocol AccountMenuRouter {
    func presentPersonalDetails()
    func presentShoppingCart()
    func presentOrderHistory()
    func presentFavoriteList()
}

class AccountMenuPresenterImpl: ListPresenter {
    
    enum Row: Int, CaseIterable {
        case profile
        case cart
        case orders
        case favorites
    }
    
    private weak var view: ListView?
    private let router: AccountMenuRouter
    private let isCartEmptyUseCase: IsCartEmptyUseCase
    
    // MARK: - Initializers
    
    init(view: ListView?, router: AccountMenuRouter, isCartEmptyUseCase: IsCartEmptyUseCase) {
        self.view = view
        self.router = router
        self.isCartEmptyUseCase = isCartEmptyUseCase
    }
    
    // MARK: - ListPresenter
    
    func viewDidLoad() {
        view?.display(title: "my account")
    }
    
    var rowCount: Int {
        Row.allCases.count
    }
    
    func getTitle(forRow row: Int) -> String {
        let row = Row(rawValue: row)
        
        switch row {
        case .profile:   return "personal details"
        case .cart:      return "shopping bag"
        case .orders:    return "order history"
        case .favorites: return "favorite list"
        default: fatalError()
            
        }
    }
    
    func didSelect(row: Int) {
        let row = Row(rawValue: row)
        
        switch row {
        case .profile:   return router.presentPersonalDetails()
        case .cart:      return router.presentShoppingCart()
        case .orders:    return router.presentOrderHistory()
        case .favorites: return router.presentFavoriteList()
        default: fatalError() }
    }
    
    func cartButtonTapped() {
        router.presentShoppingCart()
    }
}
