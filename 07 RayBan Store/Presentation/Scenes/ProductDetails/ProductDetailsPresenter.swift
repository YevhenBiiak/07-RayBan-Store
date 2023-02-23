//
//  ProductDetailsPresenter.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 18.09.2022.
//

import Foundation

protocol ProductDetailsRouter {
}

@MainActor
protocol ProductDetailsView: AnyObject {
    func display(viewModel: ProductDetailsViewModel)
    func displayError(title: String, message: String?)
}

protocol ProductDetailsPresenter {
    func viewDidLoad() async
    func didSelectColorSegment(at index: Int) async
    func cartButtonTapped() async
}

class ProductDetailsPresenterImpl {
    
    private weak var view: ProductDetailsView?
    private let router: ProductDetailsRouter
    private let getProductsUseCase: GetProductsUseCase
    
    private var product: Product
    private var currentVariationIndex = 0
    
    init(product: Product, view: ProductDetailsView?, router: ProductDetailsRouter, getProductsUseCase: GetProductsUseCase) {
        self.product = product
        self.view = view
        self.router = router
        self.getProductsUseCase = getProductsUseCase
    }
}

extension ProductDetailsPresenterImpl: ProductDetailsPresenter {
    
    func viewDidLoad() async {
        await updateView()
        
        await with(errorHandler) {
            let productIDRequest = ProductWithIDRequest(productID: product.variations[0].productID)
            product.variations[0] = try await getProductsUseCase.execute(productIDRequest).variations[0]
            await updateView()
            
            // load all images for variations and display selected
            let request = ProductWithModelIDRequest(modelID: product.modelID)
            product = try await getProductsUseCase.execute(request)
            await updateView()
        }
    }
    
    func didSelectColorSegment(at index: Int) async {
        currentVariationIndex = index
        await updateView()
    }
    
    func cartButtonTapped() async {
        print("cartButtonTapped")
    }
}

// MARK: - Private methods

extension ProductDetailsPresenterImpl {
    
    private func updateView() async {
        let viewModel = createProductViewModel(with: product)
        await view?.display(viewModel: viewModel)
    }
    
    private func createProductViewModel(with product: Product) -> ProductDetailsViewModel {
        let selectedVariation = product.variations[currentVariationIndex]
        return ProductDetailsViewModel(
            modelID: product.modelID,
            productID: selectedVariation.productID,
            name: product.name.uppercased(),
            category: product.category.rawValue.uppercased(),
            gender: product.gender.rawValue.uppercased(),
            style: product.style.rawValue.uppercased(),
            size: product.size.uppercased(),
            geofit: product.geofit.uppercased(),
            colors: product.variations.map { "\($0.frameColor)/\($0.lenseColor)".uppercased() },
            frameColor: selectedVariation.frameColor,
            lenseColor: selectedVariation.lenseColor,
            selectedColorIndex: currentVariationIndex,
            price: "$ " + String(format: "%.2f", Double(selectedVariation.price) / 100.0),
            details: product.details,
            imageData: selectedVariation.imageData ?? [])
    }
    
    private func errorHandler(_ error: Error) async {
        await view?.displayError(title: error.localizedDescription, message: nil)
    }
}
