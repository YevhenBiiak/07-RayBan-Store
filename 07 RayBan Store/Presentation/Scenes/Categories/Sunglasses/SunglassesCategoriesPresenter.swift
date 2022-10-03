//
//  SunglassesCategoriesPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 01.10.2022.
//

import Foundation

class SunglassesCategoriesPresenterImpl: CategoriesPresenter {

    private weak var view: CategoriesView?
    private let router: CategoriesRouter
    private let getProductsUseCase: GetProductsUseCase
    
    private var products: [ProductDTO] = []
    
    // MARK: - Initializers
    
    init(view: CategoriesView?, router: CategoriesRouter, getProductsUseCase: GetProductsUseCase) {
        self.view = view
        self.router = router
        self.getProductsUseCase = getProductsUseCase
    }
    
    // MARK: - CategoriesPresenter
    
    func viewDidLoad() {
        view?.display(title: ProductType.sunglasses.rawValue)
        let request = GetProductsRequest(query: .productFamiliesDescription(ofType: .sunglasses))
        getProductsUseCase.execute(request) { [weak self]  (result: Result<GetProductsResponse>) in
            switch result {
            case .success(let response):
                self?.products = response.products
                self?.view?.display(viewModels: response.products.asProductsViewModel)
            case .failure(let error):
                self?.view?.displayError(title: error.localizedDescription, message: nil)
            }
            
        }
    }
    
    // swiftlint:disable opening_brace
    func closeButtonTapped()    { router.returnToProducts() }
    func didTapMensProducts()   { router.presentProducts(category: .men) }
    func didTapWomensProducts() { router.presentProducts(category: .women) }
    func didTapKidsProducts()   { router.presentProducts(category: .kids) }
    func didTapAllProducts()    { router.presentProducts(category: .all) }
    // swiftlint:enable opening_brace
    
    func didSelectItem(atIndex index: Int) {
        
        let product = products[index]
        let productFamily = product.productFamily.lowercased()
        
        guard let family = ProductFamily(rawValue: productFamily)
        else { return print("ERROR: invalid family rawValue of product", product) }
        
        router.presentProducts(family: family)
    }
}
