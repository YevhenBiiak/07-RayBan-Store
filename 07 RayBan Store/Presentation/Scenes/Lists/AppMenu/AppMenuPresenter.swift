//
//  AppMenuPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 25.09.2022.
//

import Foundation

@MainActor
protocol AppMenuRouter {
    func presentAccountMenu()
    func presentSunglassesCategories()
    func presentEyeglassesCategories()
    func presentShoppingCart()
}

class AppMenuPresenterImpl: ListPresenter {

    enum Row: Int, CaseIterable {
        case account
        case sunglasses
        case eyeglasses
    }
    
    private weak var view: ListView?
    private let router: AppMenuRouter
    private let cartUseCase: CartUseCase
    
    // MARK: - Initializers
    
    init(view: ListView?, router: AppMenuRouter, cartUseCase: CartUseCase) {
        self.view = view
        self.router = router
        self.cartUseCase = cartUseCase
    }
    
    // MARK: - ListPresenter
    
    func viewDidLoad() async {
        await updateView()
    }
    
    func viewWillAppear() async {
        await updateView()
    }
    
    var numberOfRows: Int {
        Row.allCases.count
    }
    
    func text(for row: Int) -> String {
        switch Row(rawValue: row)! {
        case .account:    return "MY ACCOUNT"
        case .sunglasses: return "SUNGLASSES"
        case .eyeglasses: return "EYEGLASSES" }
    }
    
    func didSelect(row: Int) async {
        switch Row(rawValue: row)! {
        case .account:    return await router.presentAccountMenu()
        case .sunglasses: return await router.presentSunglassesCategories()
        case .eyeglasses: return await router.presentEyeglassesCategories() }
    }
    
    func cartButtonTapped() async {
        await router.presentShoppingCart()
    }
}

// MARK: - Private extension

extension AppMenuPresenterImpl {
    
    private func updateView() async {
        await with(errorHandler) {
            let isCartEmptyRequest = IsCartEmptyRequest(user: Session.shared.user)
            let isCartEmpty = try await cartUseCase.execute(isCartEmptyRequest)
            isCartEmpty ? await view?.hideCartBadge() : await view?.displayCartBadge()
        }
    }
    
    private func errorHandler(_ error: Error) async {
        await view?.displayError(title: "Error", message: error.localizedDescription)
    }
}
