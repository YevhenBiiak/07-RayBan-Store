//
//  AppMenuPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 25.09.2022.
//

import Foundation

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
    private let isCartEmptyUseCase: IsCartEmptyUseCase
    
    // MARK: - Initializers
    
    init(view: ListView?, router: AppMenuRouter, isCartEmptyUseCase: IsCartEmptyUseCase) {
        self.view = view
        self.router = router
        self.isCartEmptyUseCase = isCartEmptyUseCase
    }
    
    // MARK: - ListPresenter
    
    func viewDidLoad() {}
    
    var numberOfItems: Int {
        Row.allCases.count
    }
    
    func getTitle(forRow row: Int) -> String {
        let row = Row(rawValue: row)
        
        switch row {
        case .account:    return "my account"
        case .sunglasses: return "sunglasses"
        case .eyeglasses: return "eyeglasses"
        default: fatalError() }
    }
    
    func didSelect(row: Int) {
        let row = Row(rawValue: row)
        
        switch row {
        case .account:    return router.presentAccountMenu()
        case .sunglasses: return router.presentSunglassesCategories()
        case .eyeglasses: return router.presentEyeglassesCategories()
        default: fatalError() }
    }
    
    func cartButtonTapped() {
        router.presentShoppingCart()
    }
}
