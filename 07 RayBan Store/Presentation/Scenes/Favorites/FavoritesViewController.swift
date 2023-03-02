//
//  FavoritesViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 01.03.2023.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var configurator: FavoritesConfigurator!
    var presenter: FavoritesPresenter!
    var rootView: FavoritesRootView!
    
    private var section: Sectionable!
    
    // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(favoritesViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        Task { await presenter.viewDidLoad() }
    }
    
    private func setupCollectionView() {
        rootView.сollectionView.delegate = self
        rootView.сollectionView.dataSource = self
        rootView.сollectionView.register(FavoritesViewCell.self, forCellWithReuseIdentifier: FavoritesViewCell.reuseId)
    }
}

extension FavoritesViewController: FavoritesView {
    
    func display(title: String) {
        self.title = title
    }
    
    func display(section: Sectionable) {
        self.section = section
        rootView.сollectionView.reloadData()
    }
    
    func displayError(title: String, message: String?) {
        showAlert(title: title, message: message, buttonTitle: "OK")
    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.section?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesViewCell.reuseId, for: indexPath)
        
        (cell as? FavoritesViewCell)?.viewModel = section.items[indexPath.item].viewModel as? FavoriteItemViewModel
        
        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = section.items[indexPath.item]
        Task { await presenter.didSelectItem(item) }
    }
}
