//
//  SunglassesCategoriesRouter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 01.10.2022.
//

class SunglassesCategoriesRouterImpl: CategoriesRouter {
    
    private unowned var sunglassesCategoriesViewController: CategoriesViewController
    private weak var productsPresentationDelegate: ProductsPresentationDelegate?
    
    init(sunglassesCategoriesViewController: CategoriesViewController,
         productsPresentationDelegate: ProductsPresentationDelegate?
    ) {
        self.sunglassesCategoriesViewController = sunglassesCategoriesViewController
        self.productsPresentationDelegate = productsPresentationDelegate
    }
    
    func returnToProducts() {
        sunglassesCategoriesViewController.navigationController?.popToRootViewController(animated: true)
    }
    
    func presentAllProducts() {
        Task { await productsPresentationDelegate?.presentProducts(category: .sunglasses) }
        returnToProducts()
    }
    
    func presentProducts(gender: Product.Gender) {
        Task { await productsPresentationDelegate?.presentProducts(category: .sunglasses, gender: gender) }
        returnToProducts()
    }
    
    func presentProducts(style: Product.Style) {
        Task { await productsPresentationDelegate?.presentProducts(category: .sunglasses, style: style) }
        returnToProducts()
    }
}
