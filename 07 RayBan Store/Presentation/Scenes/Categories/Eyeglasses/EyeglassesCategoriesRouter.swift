//
//  EyeglassesCategoriesRouter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.10.2022.
//

import Foundation

// swiftlint:disable opening_brace
class EyeglassesCategoriesRouterImpl: CategoriesRouter {
    
    private unowned var eyeglassesCategoriesViewController: CategoriesViewController
    private weak var productsPresentationDelegate: ProductsPresentationDelegate?
    
    init(eyeglassesCategoriesViewController: CategoriesViewController,
         productsPresentationDelegate: ProductsPresentationDelegate?)
    {
        self.eyeglassesCategoriesViewController = eyeglassesCategoriesViewController
        self.productsPresentationDelegate = productsPresentationDelegate
    }
    
    func returnToProducts() {
        eyeglassesCategoriesViewController.navigationController?.popToRootViewController(animated: true)
    }
    
    func presentAllProducts() {
        productsPresentationDelegate?.presentProducts(type: .eyeglasses)
        returnToProducts()
    }
    
    func presentProducts(category: ProductCategory) {
        productsPresentationDelegate?.presentProducts(type: .eyeglasses, category: category)
        returnToProducts()
    }
    
    func presentProducts(family: ProductFamily) {
        productsPresentationDelegate?.presentProducts(type: .eyeglasses, family: family)
        returnToProducts()
    }
}
