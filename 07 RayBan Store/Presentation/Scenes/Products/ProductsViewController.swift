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
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, ProductVM>!
    
    private var isProductsLoading = false
    private var products: [ProductVM] = []
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
            // scroll to top
            let topBarHeight = (self?.statusBarHeight ?? 0) + (self?.navigationBarHeight ?? 0) + 44
            self?.rootView.collectionView.setContentOffset(CGPoint(x: 0, y: -topBarHeight), animated: false)
        }
    }
    
    func display(products: [ProductVM], totalNumberOfProducts: Int) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Int, ProductVM>()
            snapshot.appendSections([0])
            snapshot.appendItems(products)
            self.dataSource.apply(snapshot, animatingDifferences: false)
            
//            guard !products.isEmpty
//            else { return self.setInitialStateForDataSource() }
//
//            let newProducts = products.insertedDifference(from: self.products)
//            var snapshot = self.dataSource.snapshot()
//            snapshot.appendItems(newProducts)
//            self.dataSource.apply(snapshot)
            self.products = products
            print("sections:", self.dataSource.numberOfSections(in: self.rootView.collectionView))
//            self.isProductsLoading = false
//            self.totalNumberOfProducts = totalNumberOfProducts
//            if totalNumberOfProducts != 0, products.count != self.products.count {
//                let range = self.products.count...products.count - 1
//                self.products = products
//                print(range)
//                let paths = range.map { IndexPath(item: $0, section: 0) }
//                self.rootView.collectionView.reloadItems(at: paths)
//            } else {
//                self.products = products
//                self.rootView.collectionView.reloadData()
//            }
            print("collectionView.reloadData(): ", products.count)
        }
    }
    
    func display(numberOfLoadingProducts: Int) {
        DispatchQueue.main.async {
//            self.isProductsLoading = true
//            let range = self.products.count...self.products.count + numberOfLoadingProducts - 1
//            let paths = range.map { IndexPath(item: $0, section: 0) }
//            self.rootView.collectionView.reloadItems(at: paths)
        }
    }
    
    func displayError(title: String, message: String?) {
        DispatchQueue.main.async {
            print("ERROR: ", title)
        }
    }
    
    // MARK: - Private methods
    
    private func setupCollectinView() {
        rootView.collectionView.delegate = self
        
        let cellRegistration = UICollectionView.CellRegistration<ProductsViewCell, ProductVM> { (cell, _, product) in
            cell.configure(with: product)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, ProductVM>(collectionView: rootView.collectionView, cellProvider: { collectionView, indexPath, product in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        })
        
        setInitialStateForDataSource()
    }
    
    private func setInitialStateForDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ProductVM>()
        snapshot.appendSections([0])
        dataSource.apply(snapshot, animatingDifferences: false)
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

//extension ProductsViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return isProductsLoading ? products.count + 10 : products.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsViewCell.reuseId, for: indexPath)
//        guard let cell = cell as? ProductsViewCell else { return cell }
//        print(indexPath)
//        if indexPath.item < products.count {
//            let product = products[indexPath.item]
//            cell.configure(with: product)
//        } else {
//            cell.startLoadingAnimation()
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let reusableView = collectionView.dequeueReusableSupplementaryView(
//            ofKind: HeaderReusableView.elementKind,
//            withReuseIdentifier: HeaderReusableView.reuseId, for: indexPath)
//
//        guard let headerView = reusableView as? HeaderReusableView
//        else { return reusableView }
//
//        headerView.setProducts(count: totalNumberOfProducts)
//
//        return reusableView
//    }
//}

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
