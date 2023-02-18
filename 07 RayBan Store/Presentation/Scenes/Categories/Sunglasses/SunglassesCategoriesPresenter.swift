//
//  SunglassesCategoriesPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 01.10.2022.
//

//import Foundation
//
//class SunglassesCategoriesPresenterImpl: CategoriesPresenter {
//
//    private weak var view: CategoriesView?
//    private let router: CategoriesRouter
//    private let getProductsUseCase: GetProductsUseCase
//    
//    // MARK: - Initializers
//    
//    init(view: CategoriesView?, router: CategoriesRouter, getProductsUseCase: GetProductsUseCase) {
//        self.view = view
//        self.router = router
//        self.getProductsUseCase = getProductsUseCase
//    }
//    
//    // MARK: - CategoriesPresenter
//    
//    func viewDidLoad() async {
//        await view?.display(title: ProductType.sunglasses.rawValue)
//        await view?.displayLoading(categoriesCount: 7)
//        
//        let request = ProductFamiliesRequest(type: .sunglasses)
//        do {/* execute request */
//            let products = try await getProductsUseCase.execute(request)
//            await view?.display(categories: products.asCategoriesVM)
//        } catch {
//            print(error)
//            await view?.displayError(title: error.localizedDescription, message: nil)
//        }
//    }
//    
//    func closeButtonTapped() async    { await router.returnToProducts() }
//    func didTapMensProducts() async   { await router.presentProducts(category: .men) }
//    func didTapWomensProducts() async { await router.presentProducts(category: .women) }
//    func didTapKidsProducts() async   { await router.presentProducts(category: .kids) }
//    func didTapAllProducts() async    { await router.presentAllProducts() }
//    
//    func didSelect(productFamily: String) async {
//        guard let family = ProductFamily(rawValue: productFamily.lowercased())
//        else { return print("ERROR: invalid family rawValue", productFamily) }
//        
//        await router.presentProducts(family: family)
//    }
//}
