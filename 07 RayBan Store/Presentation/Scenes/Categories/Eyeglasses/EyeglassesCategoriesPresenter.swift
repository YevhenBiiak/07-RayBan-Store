//
//  EyeglassesCategoriesPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.10.2022.
//

import Foundation

class EyeglassesCategoriesPresenterImpl: CategoriesPresenter {

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
        view?.display(title: ProductType.eyeglasses.rawValue)
        let request = GetProductsRequest(queries: .representationOfProductFamilies(ofType: .eyeglasses))
        getProductsUseCase.execute(request) { [weak self]  (result: Result<GetProductsResponse>) in
            switch result {
            case .success(let response):
                self?.products = response.products
                self?.view?.display(viewModels: response.products.asProductFamilyVM)
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
    func didTapAllProducts()    { router.presentAllProducts() }
    // swiftlint:enable opening_brace
    
    func didSelect(productFamily: String) {
        guard let family = ProductFamily(rawValue: productFamily.lowercased())
        else { return print("ERROR: invalid family rawValue", productFamily) }
        
        router.presentProducts(family: family)
    }
}
