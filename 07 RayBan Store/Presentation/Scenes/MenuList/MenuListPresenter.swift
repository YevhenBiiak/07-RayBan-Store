//
//  MenuListPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 25.09.2022.
//

import Foundation

protocol MenuListRouter {
    
}

protocol MenuListView: AnyObject {
    
}

protocol MenuListPresenter {
    var rowCount: Int { get }
    func getTitle(forRow row: Int) -> String
    func cartButtonTapped()
    func accountButtonTapped()
    func sunglassesButtonTapped()
    func eyeglassesButtonTappde()
}

class MenuListPresenterImpl: MenuListPresenter {
    
    enum Row: Int, CaseIterable {
        case account
        case sunglasses
        case eyeglasses
    }
    
    private weak var view: MenuListView?
    private let router: MenuListRouter
    private let isCartEmptyUseCase: IsCartEmptyUseCase
    
    // MARK: - Initializers
    
    init(view: MenuListView?, router: MenuListRouter, isCartEmptyUseCase: IsCartEmptyUseCase) {
        self.view = view
        self.router = router
        self.isCartEmptyUseCase = isCartEmptyUseCase
    }
    
    // MARK: - MenuListPresenter
    
    var rowCount: Int {
        Row.allCases.count
    }
    
    func getTitle(forRow row: Int) -> String {
        let row = Row(rawValue: row)
        
        switch row {
        case .account:    return "my account"
        case .sunglasses: return "sunglasses"
        case .eyeglasses: return "eyeglasses"
        default: fatalError()
        }
    }
    
    func cartButtonTapped() {
        
    }
    func accountButtonTapped() {
        
    }
    func sunglassesButtonTapped() {
        
    }
    func eyeglassesButtonTappde() {
        
    }
}
