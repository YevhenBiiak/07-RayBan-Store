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
        setupViews()
        Task { await presenter.viewDidLoad() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard section?.items.isEmpty == false else { return }
        Task { await presenter.viewWillAppear() }
    }
    
    private func setupViews() {
        rootView.сollectionView.delegate = self
        rootView.сollectionView.dataSource = self
        rootView.сollectionView.register(FavoritesViewCell.self, forCellWithReuseIdentifier: FavoritesViewCell.reuseId)
        
        rootView.activityIndicator.startAnimating()
    }
}

extension FavoritesViewController: FavoritesView {
    
    func display(title: String) {
        self.title = title
    }
    
    func display(section: Sectionable) {
        self.section = section
        rootView.сollectionView.reloadData()
        
        rootView.activityIndicator.stopAnimating()
        section.items.isEmpty
            ? rootView.emptyStateView.show()
            : rootView.emptyStateView.hide()
    }
    
    func displayError(title: String, message: String?) {
        showAlert(title: title, message: message)
    }
}

extension FavoritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.section?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(FavoritesViewCell.self, for: indexPath) { cell in
            cell.viewModel = section.items[indexPath.item].viewModel as? FavoriteItemViewModel
        }
    }
}

extension FavoritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = section.items[indexPath.item]
        Task { await presenter.didSelectItem(item) }
    }
}
