//
//  SunglassesCategoriesRouter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 01.10.2022.
//

import UIKit

// swiftlint:disable opening_brace
class SunglassesCategoriesRouterImpl: CategoriesRouter {
    
    private unowned var sunglassesCategoriesViewController: CategoriesViewController
    private weak var productsPresentationDelegate: ProductsPresentationDelegate?
    
    init(sunglassesCategoriesViewController: CategoriesViewController,
         productsPresentationDelegate: ProductsPresentationDelegate?)
    {
        self.sunglassesCategoriesViewController = sunglassesCategoriesViewController
        self.productsPresentationDelegate = productsPresentationDelegate
    }
    
    func returnToProducts() {
        sunglassesCategoriesViewController.navigationController?.popToRootViewController(animated: true)
    }
    
    func presentAllProducts() {
        productsPresentationDelegate?.presentProducts(type: .sunglasses)
        returnToProducts()
    }
    
    func presentProducts(category: ProductCategory) {
        productsPresentationDelegate?.presentProducts(type: .sunglasses, category: category)
        returnToProducts()
    }
    
    func presentProducts(family: ProductFamily) {
        productsPresentationDelegate?.presentProducts(type: .sunglasses, family: family)
        returnToProducts()
    }
}
