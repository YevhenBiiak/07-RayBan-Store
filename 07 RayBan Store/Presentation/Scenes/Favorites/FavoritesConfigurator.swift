//
//  FavoritesConfigurator.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 01.03.2023.
//

@MainActor
protocol FavoritesConfigurator {
    func configure(favoritesViewController: FavoritesViewController)
}

class FavoritesConfiguratorImpl: FavoritesConfigurator {
    
    func configure(favoritesViewController: FavoritesViewController) {
        
        let productImagesApi = ProductImagesApiImpl()
        let remoteRepository = Session.shared.remoteRepositoryAPI
        let productGateway = ProductGatewayImpl(productsAPI: remoteRepository, imagesApi: productImagesApi)
        
        let favoriteGateway = FavoriteGatewayImpl(favoriteAPI: remoteRepository, productGateway: productGateway)
        let favoriteUseCase = FavoriteUseCaseImpl(favoriteGateway: favoriteGateway)
        
        let rootView = FavoritesRootView()
        let router = FavoritesRouterImpl(viewController: favoritesViewController)
        let presenter = FavoritesPresenterImpl(view: favoritesViewController,
                                               router: router,
                                               favoriteUseCase: favoriteUseCase)
        
        favoritesViewController.presenter = presenter
        favoritesViewController.rootView = rootView
    }
}
