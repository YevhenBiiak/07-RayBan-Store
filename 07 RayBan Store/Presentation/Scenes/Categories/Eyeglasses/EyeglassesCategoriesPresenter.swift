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
        Task {
            view?.display(title: ProductType.eyeglasses.rawValue)
            view?.displayLoading(categoriesCount: 5)
            
            let request = GetProductsRequest(queries: .representationOfProductFamilies(ofType: .eyeglasses))
            do {/* execute request */
                let response = try await getProductsUseCase.execute(request)
                products = response.products
                view?.display(categories: response.products.asCategoriesVM)
            } catch {
                print(error)
                view?.displayError(title: error.localizedDescription, message: nil)
            }
        }
    }
    
    func closeButtonTapped() {    router.returnToProducts() }
    func didTapMensProducts() {   router.presentProducts(category: .men) }
    func didTapWomensProducts() { router.presentProducts(category: .women) }
    func didTapKidsProducts() {   router.presentProducts(category: .kids) }
    func didTapAllProducts() {    router.presentAllProducts() }
    
    func didSelect(productFamily: String) {
        guard let family = ProductFamily(rawValue: productFamily.lowercased())
        else { return print("ERROR: invalid family rawValue", productFamily) }
        
        router.presentProducts(family: family)
    }
}
