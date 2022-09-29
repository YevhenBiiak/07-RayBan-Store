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
    
    private var viewModels: [ProductViewModel] = []
    
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
    
    // MARK: - ProductsView
    
    func display(title: String) {
        self.title = title
        // bug: title alpha is zero in iOS 16
        if #available(iOS 16.0, *) {
            navigationController?.navigationBar.setNeedsLayout()
        }
    }
    
    func display(viewModels: [ProductViewModel]) {
        self.viewModels = viewModels
        rootView.productsCollectionView.reloadData()
    }
    
    func displayError(title: String, message: String?) {
        print("ERROR: ", title)
    }
    
    // MARK: - Private methods
    
    private func setupCollectinView() {
        rootView.productsCollectionView.register(ProductsViewCell.self,
            forCellWithReuseIdentifier: ProductsViewCell.identifier)
        
        rootView.productsCollectionView.register(HeaderReusableView.self,
            forSupplementaryViewOfKind: HeaderReusableView.elementKind,
            withReuseIdentifier: HeaderReusableView.identifier)
        
        rootView.productsCollectionView.dataSource = self
        rootView.productsCollectionView.delegate = self
    }
    
    private func setupNavigationBar() {
        // set custom font and color for title 
        navigationController?.navigationBar.tintColor = UIColor.appDarkGray
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.Oswald.medium.withSize(22)]
        
        // add BarButtonItem to rightBarButtonItems
        let menuButton = UIButton.buttonWithSFImage(
            name: "line.3.horizontal",
            color: UIColor.appBlack,
            size: 19, weight: .semibold)
        
        // add actions
        menuButton.addAction(UIAction(handler: { [weak self] _ in
            self?.presenter.menuButtonTapped()
        }), for: .touchUpInside)
        
        // set button items
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        // add logo image to navigationItems
        let logo = UIImage(named: "logo")!
        navigationItem.addLogoImage(logo)
    }
}

// MARK: - UICollectionViewDataSource

extension ProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsViewCell.identifier, for: indexPath)
        
        if let cell = cell as? ProductsViewCell {
            let product = viewModels[indexPath.item]
            
            cell.setIsNew(flag: true)
            cell.setTitle(product.title)
            
            cell.setImage(product.images.first)
            cell.setPrice(product.price)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: HeaderReusableView.elementKind,
            withReuseIdentifier: HeaderReusableView.identifier, for: indexPath)
        
        if let headerView = reusableView as? HeaderReusableView {
            headerView.setProducts(count: viewModels.count)
        }
        
        return reusableView
    }
}

// MARK: - UICollectionViewDelegate

extension ProductsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItems(atIndexPath: indexPath)
    }
}
