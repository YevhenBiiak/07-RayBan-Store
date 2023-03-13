//
//  EyeglassesCategoriesPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.10.2022.
//

import Foundation

class EyeglassesCategoriesPresenterImpl {
    
    private weak var view: CategoriesView?
    private let router: CategoriesRouter
    private let getProductsUseCase: GetProductsUseCase
    
    private var isLoading = true
        
    init(view: CategoriesView?, router: CategoriesRouter, getProductsUseCase: GetProductsUseCase) {
        self.view = view
        self.router = router
        self.getProductsUseCase = getProductsUseCase
    }
}

extension EyeglassesCategoriesPresenterImpl: CategoriesPresenter {
    
    func viewDidLoad() async {
        
        let headerSection = CategorySection(items: [
            CategoryItem(viewModel: CategoryCellViewModel(name: "MEN")),
            CategoryItem(viewModel: CategoryCellViewModel(name: "WOMEN")),
            CategoryItem(viewModel: CategoryCellViewModel(name: "KIDS")),
            CategoryItem(viewModel: CategoryCellViewModel(name: "ALL EYEGLASSES"))
        ])
        let productSection = CategorySection(items: [CategoryItem()])
        
        await view?.display(title: "EYEGLASSES")
        await view?.display(headerSection: headerSection)
        await view?.display(productSection: productSection)
        
        await with(errorHandler) {
            let request = ProductStylesRequest(category: .eyeglasses, includeImages: true)
            let products = try await getProductsUseCase.execute(request)
            isLoading = false
            
            let viewModels = products.map { CategoryCellViewModel(
                name: $0.style.rawValue.uppercased(),
                imageData: $0.variations.first?.imageData?.first)
            }
            let items = viewModels.map { CategoryItem(viewModel: $0)}
            let section = CategorySection(items: items)
            await view?.display(productSection: section)
        }
    }
    
    func willDisplayLastProduct(at index: Int) async {
        guard index < 5, isLoading else { return }
        await view?.display(productItem: CategoryItem(), at: index + 1)
    }
    
    func didSelectHeader(at index: Int) async {
        switch index {
        case 0: Task { await router.presentProducts(gender: .male) }
        case 1: Task { await router.presentProducts(gender: .female) }
        case 2: Task { await router.presentProducts(gender: .kids) }
        case 3: Task { await router.presentAllProducts() }
        default: break }
    }
    
    func didSelectProduct(at index: Int) async {
        await with(errorHandler) {
            let request = ProductStylesRequest(category: .eyeglasses, includeImages: false)
            let products = try await getProductsUseCase.execute(request)
            guard index < products.count else { return }
            await router.presentProducts(style: products[index].style)
        }
    }
    
    func closeButtonTapped() async {
        await router.returnToProducts()
    }
}

// MARK: - Private extension

private extension EyeglassesCategoriesPresenterImpl {
    
    func errorHandler(_ error: Error) async {
        await view?.displayError(title: "Error", message: error.localizedDescription)
    }
}
