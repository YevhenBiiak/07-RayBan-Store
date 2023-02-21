//
//  EyeglassesCategoriesRouter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.10.2022.
//

import Foundation

class EyeglassesCategoriesRouterImpl: CategoriesRouter {
    
    private unowned var eyeglassesCategoriesViewController: CategoriesViewController
    private weak var productsPresentationDelegate: ProductsPresentationDelegate?
    
    init(eyeglassesCategoriesViewController: CategoriesViewController,
         productsPresentationDelegate: ProductsPresentationDelegate?
    ) {
        self.eyeglassesCategoriesViewController = eyeglassesCategoriesViewController
        self.productsPresentationDelegate = productsPresentationDelegate
    }
    
    func returnToProducts() {
        eyeglassesCategoriesViewController.navigationController?.popToRootViewController(animated: true)
    }
    
    func presentAllProducts() {
        Task { await productsPresentationDelegate?.presentProducts(category: .eyeglasses) }
        returnToProducts()
    }
    
    func presentProducts(gender: Product.Gender) {
        Task { await productsPresentationDelegate?.presentProducts(category: .eyeglasses, gender: gender) }
        returnToProducts()
    }
    
    func presentProducts(style: Product.Style) {
        Task { await productsPresentationDelegate?.presentProducts(category: .eyeglasses, style: style) }
        returnToProducts()
    }
}
