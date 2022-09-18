//
//  ProductsViewController.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import UIKit

class ProductsViewController: UIViewController, ProductsView {
    
    var configurator: ProductsConfigurator!
    var presenter: ProductsPresenter!
    var rootView: ProductsRootView!
    
    override func loadView() {
        configurator.configure(productsViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectinView()
        setupNavigationBar()
        presenter.viewDidLoad()
    }
    
    private func setupCollectinView() {
        rootView.productsCollectionView.register(ProductsCollectionViewCell.self, forCellWithReuseIdentifier: ProductsCollectionViewCell.cellIdentifier)
        
        rootView.productsCollectionView.dataSource = self
        rootView.productsCollectionView.delegate = self
    }
    
    private func setupNavigationBar() {
        // set largeTitle style, set custom font
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.Oswald.medium.withSize(0.1)]
        navigationController?.navigationBar.largeTitleTextAttributes = [.font: UIFont.Oswald.medium.withSize(30)]
        
        // add logo image to navigationBar
        let logo = UIImage(named: "logo")!
        navigationController?.navigationBar.addLogoImage(logo)
        
        // add BarButtonItems to rightBarButtonItems
        let searchButton = UIButton.buttonWithSFImage(name: "magnifyingglass", color: UIColor.appBlack, size: 15, weight: .semibold)
        let cartButton = UIButton.buttonWithSFImage(name: "cart", color: UIColor.appBlack, size: 17, weight: .semibold)
        let menuButton = UIButton.buttonWithSFImage(name: "line.3.horizontal", color: UIColor.appBlack, size: 19, weight: .semibold)
        
        // add actions
        searchButton.addAction(UIAction(handler: { [weak self] _ in
            self?.presenter.searchButtonTapped()
        }), for: .touchUpInside)
        
        cartButton.addAction(UIAction(handler: { [weak self] _ in
            self?.presenter.cartButtonTapped()
        }), for: .touchUpInside)
        
        menuButton.addAction(UIAction(handler: { [weak self] _ in
            self?.presenter.menuButtonTapped()
        }), for: .touchUpInside)
        
        // set button items
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: menuButton),
            UIBarButtonItem(customView: cartButton),
            UIBarButtonItem(customView: searchButton)
        ]
        
    }
    
    // MARK: - ProductsView
    
    func displayTitle(_ title: String) {
        self.title = title
    }
    
    func displayError(title: String, message: String?) {
        self.title = title
    }
    
    func reloadView() {
        rootView.productsCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfProducts()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.cellIdentifier, for: indexPath)
        
        if let cell = cell as? ProductsCollectionViewCell {
            presenter.configure(cell: cell, forRowAt: indexPath)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProductsViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProductsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width
        let cellWidth = availableWidth / 2
        let cellHeight = cellWidth + 110

        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
