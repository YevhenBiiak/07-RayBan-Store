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
    
    private var viewModels: [ProductVM] = []
    private var totalNumberOfProducts = 0
    
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
        DispatchQueue.main.async { [weak self] in
            self?.title = title.uppercased()
            // bug: title alpha is zero in iOS 16
            if #available(iOS 16.0, *) {
                self?.navigationController?.navigationBar.setNeedsLayout()
            }
        }
    }
    
    func display(viewModels: [ProductVM], totalNumberOfProducts: Int) {
        self.viewModels = viewModels
        self.totalNumberOfProducts = totalNumberOfProducts
        DispatchQueue.main.async { [weak self] in
            self?.rootView.collectionView.reloadData()
        }
    }
    
    func displayError(title: String, message: String?) {
        DispatchQueue.main.async {
            print("ERROR: ", title)
        }
    }
    
    // MARK: - Private methods
    
    private func setupCollectinView() {
        rootView.collectionView.register(ProductsViewCell.self,
            forCellWithReuseIdentifier: ProductsViewCell.reuseId)
        
        rootView.collectionView.register(HeaderReusableView.self,
            forSupplementaryViewOfKind: HeaderReusableView.elementKind,
            withReuseIdentifier: HeaderReusableView.reuseId)
        
        rootView.collectionView.dataSource = self
        rootView.collectionView.delegate = self
    }
    
    private func setupNavigationBar() {
        // set custom font and color for title
        navigationController?.navigationBar.tintColor = UIColor.appDarkGray
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont.Oswald.medium.withSize(22)]
        
        // add BarButtonItem to rightBarButtonItems
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal", tintColor: .appBlack, pointSize: 20, weight: .semibold),
            style: .plain,
            target: self,
            action: #selector(menuButtonTapped))
        
        // add logo image to navigationItems
        let logo = UIImage(named: "logo")!
        navigationItem.addLogoImage(logo)
    }
    
    @objc private func menuButtonTapped() {
        presenter.menuButtonTapped()
    }
}

// MARK: - UICollectionViewDataSource

extension ProductsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsViewCell.reuseId, for: indexPath)
        
        if let cell = cell as? ProductsViewCell {
            let product = viewModels[indexPath.item]
            
            cell.setIsNew(flag: true)
            cell.setTitle(product.name)
            cell.setImage(product.images.first)
            cell.setPrice(product.variations.first?.price ?? 0)
            cell.setColors(number: product.variations.count)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(
            ofKind: HeaderReusableView.elementKind,
            withReuseIdentifier: HeaderReusableView.reuseId, for: indexPath)
        
        if let headerView = reusableView as? HeaderReusableView {
            headerView.setProducts(count: totalNumberOfProducts)
        }
        
        return reusableView
    }
}

// MARK: - UICollectionViewDelegate

extension ProductsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItem(atIndexPath: indexPath)
    }
}
