//
//  AccountMenuPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 29.09.2022.
//

import Foundation

@MainActor
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
    private let cartUseCase: CartUseCase
    
    // MARK: - Initializers
    
    init(view: ListView?, router: AccountMenuRouter, cartUseCase: CartUseCase) {
        self.view = view
        self.router = router
        self.cartUseCase = cartUseCase
    }
    
    // MARK: - ListPresenter
    
    func viewDidLoad() async {
        await view?.display(title: "MY ACCOUNT")
        await with(errorHandler) {
            // display cart badge
            let isCartEmptyRequest = IsCartEmptyRequest(user: Session.shared.user)
            let isCartEmpty = try await cartUseCase.execute(isCartEmptyRequest)
            isCartEmpty ? await view?.hideCartBadge() : await view?.displayCartBadge()
        }
    }
    
    var numberOfRows: Int {
        Row.allCases.count
    }
    
    func text(for row: Int) -> String {
        switch Row(rawValue: row)! {
        case .profile:   return "PERSONAL DETAILS"
        case .cart:      return "SHOPPING BAG"
        case .orders:    return "ORDER HISTORY"
        case .favorites: return "FAVORITE LIST" }
    }
    
    func didSelect(row: Int) async {
        switch Row(rawValue: row)! {
        case .profile:   return await router.presentPersonalDetails()
        case .cart:      return await router.presentShoppingCart()
        case .orders:    return await router.presentOrderHistory()
        case .favorites: return await router.presentFavoriteList() }
    }
    
    func cartButtonTapped() async {
        await router.presentShoppingCart()
    }
}

// MARK: - Private extension

extension AccountMenuPresenterImpl {
    
    private func errorHandler(_ error: Error) async {
        await view?.displayError(title: error.localizedDescription, message: nil)
    }
}
