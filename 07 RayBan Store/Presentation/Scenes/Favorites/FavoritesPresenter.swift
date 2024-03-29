//
//  FavoritesPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 01.03.2023.
//

import Foundation

@MainActor
protocol FavoritesRouter {
    func presentProductDetails(product: Product)
}

@MainActor
protocol FavoritesView: AnyObject {
    func display(title: String)
    func display(section: any Sectionable)
    func displayError(title: String, message: String?)
}

protocol FavoritesPresenter {
    func viewDidLoad() async
    func viewWillAppear() async
    func didSelectItem(_ item: any Itemable) async
}

class FavoritesPresenterImpl {
    
    private weak var view: FavoritesView?
    private let router: FavoritesRouter
    private let favoriteUseCase: FavoriteUseCase
    
    init(view: FavoritesView?, router: FavoritesRouter, favoriteUseCase: FavoriteUseCase) {
        self.view = view
        self.router = router
        self.favoriteUseCase = favoriteUseCase
    }
}

extension FavoritesPresenterImpl: FavoritesPresenter {
    
    func viewDidLoad() async {
        await with(errorHandler) {
            await view?.display(title: "FAVORITE LIST")
            let favoriteItems = try await getFavoriteItems()
            await display(favoriteItems: favoriteItems)
        }
    }
    
    func viewWillAppear() async {
        await with(errorHandler) {
            let favoriteItems = try await getFavoriteItems()
            await display(favoriteItems: favoriteItems)
        }
    }
    
    func didSelectItem(_ item: any Itemable) async {
        await with(errorHandler) {
            guard let viewModel = (item as? FavoriteSectionItem)?.viewModel else { return }
            let favoriteItems = try await getFavoriteItems()
            guard let favoriteItem = favoriteItems.first(where: {
                $0.product.modelID == viewModel.modelID
            }) else { return }
            await router.presentProductDetails(product: favoriteItem.product)
        }
    }
}

// MARK: - Private extension

private extension FavoritesPresenterImpl {
    
    func getFavoriteItems() async throws -> [FavoriteItem] {
        let request =  GetFavoriteItemsRequest(user: Session.shared.user)
        return try await favoriteUseCase.execute(request)
    }
    
    func display(favoriteItems: [FavoriteItem]) async {
        let viewModels = favoriteItems.map(createViewModel)
        let items = viewModels.map { FavoriteSectionItem(viewModel: $0) }
        let section = FavoriteSection(items: items)
        await view?.display(section: section)
    }
    
    func createViewModel(with favoriteItems: FavoriteItem) -> FavoriteItemViewModel? {
        guard let variation = favoriteItems.product.variations.first else { return nil }
        return FavoriteItemModel(
            modelID: favoriteItems.product.modelID,
            name: favoriteItems.product.name.uppercased(),
            price: "$ " + String(format: "%.2f", Double(variation.price) / 100.0),
            frame: "Frame color: \(variation.frameColor)",
            lense: "Lense color: \(variation.lenseColor)",
            size: "Size: \(favoriteItems.product.size)",
            imageData: variation.imageData?.first ?? Data(),
            favoriteButtonTapped: { [weak self] modelID in
                await self?.deleteFavoriteItem(modelID: modelID)
            }
        )
    }
    
    func deleteFavoriteItem(modelID: ModelID) async {
        await with(errorHandler) {
            let request = DeleteFavoriteItemRequest(user: Session.shared.user, modelID: modelID, options: .image(res: .low))
            let favoriteItems = try await favoriteUseCase.execute(request)
            await display(favoriteItems: favoriteItems)
        }
    }
    
    func errorHandler(_ error: Error) async {
        await view?.displayError(title: "Error", message: error.localizedDescription)
    }
}
