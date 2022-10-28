//
//  ProductsViewController.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import UIKit

class ProductsViewController: UIViewController, ProductsView {
    
    private enum Section {
        case main
    }
    
    var configurator: ProductsConfigurator!
    var presenter: ProductsPresenter!
    var rootView: ProductsRootView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, ProductVM>!
    
    private var products: [ProductVM] = []
    private var totalNumberOfProducts = 0
    
   // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(productsViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
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
            // scroll to top
            let topBarHeight = (self?.statusBarHeight ?? 0) + (self?.navigationBarHeight ?? 0) + 44
            self?.rootView.collectionView.setContentOffset(CGPoint(x: 0, y: -topBarHeight), animated: false)
        }
    }
    
    func display(products: [ProductVM], totalNumberOfProducts: Int) {
        DispatchQueue.main.async {
            self.products = products

            var snapshot = NSDiffableDataSourceSnapshot<Section, ProductVM>()
            snapshot.appendSections([.main])
            snapshot.appendItems(products)

            if totalNumberOfProducts != self.totalNumberOfProducts {
                self.totalNumberOfProducts = totalNumberOfProducts
                self.dataSource.applySnapshotUsingReloadData(snapshot)
            } else {
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
            print("dataSource.apply(): ", products.count)
        }
    }
    
    func display(numberOfLoadingProducts: Int) {
        guard numberOfLoadingProducts > 0 else { return }
        DispatchQueue.main.async {
            let emptyProducts = (1...numberOfLoadingProducts).map { _ in ProductVM.emptyModel }
            
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems(emptyProducts)
            self.dataSource.apply(snapshot)
        }
    }
    
    func displayError(title: String, message: String?) {
        DispatchQueue.main.async {
            print("ERROR:", title)
        }
    }
    
    // MARK: - Private methods
    
    private func configureDataSource() {
        rootView.collectionView.delegate = self
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <HeaderReusableView>(elementKind: HeaderReusableView.elementKind) {
            [weak self] (headerView, _, _) in
            guard let self else { return }
            headerView.setProducts(count: self.totalNumberOfProducts)
        }
        
        let cellRegistration = UICollectionView.CellRegistration<ProductsViewCell, ProductVM> {
            [weak self] (cell, indexPath, product) in
            guard let self else { return }
            if indexPath.item < self.products.count {
                cell.configure(with: product)
            } else {
                cell.startLoadingAnimation()
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource
        <Section, ProductVM>(collectionView: rootView.collectionView, cellProvider: {
            collectionView, indexPath, product in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: product)
        })
        
        dataSource.supplementaryViewProvider = { (collectionView, _, indexPath) in
            return collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: indexPath)
        }
        
        // initial state
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductVM>()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot)
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

// MARK: - UICollectionViewDelegate

extension ProductsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < products.count {
            presenter.didSelectItem(atIndexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.willDisplayItem(forIndex: indexPath.item)
    }
}
