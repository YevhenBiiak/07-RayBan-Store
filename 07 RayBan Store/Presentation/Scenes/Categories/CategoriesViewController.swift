//
//  CategoriesViewController.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.09.2022.
//

import UIKit

protocol CategoriesRouter {
    func returnToProducts()
    func presentAllProducts()
    func presentProducts(category: ProductCategory)
    func presentProducts(family: ProductFamily)
}

protocol CategoriesConfigurator {
    func configure(categoriesViewController: CategoriesViewController)
}

protocol CategoriesPresenter {
    func viewDidLoad()
    func closeButtonTapped()
    func didTapMensProducts()
    func didTapWomensProducts()
    func didTapKidsProducts()
    func didTapAllProducts()
    func didSelect(productFamily: String)
}

protocol CategoriesView: AnyObject {
    func display(title: String)
    func display(categories: [CategoryVM])
    func displayLoading(categoriesCount: Int)
    func displayError(title: String, message: String?)
}

class CategoriesViewController: UIViewController, CategoriesView {
    
    enum Section: CaseIterable {
        case category
        case family
    }
    
    var configurator: CategoriesConfigurator!
    var presenter: CategoriesPresenter!
    var rootView: CategoriesRootView!
    
    private var categories: [CategoryVM] = []
    private var dataSource: UICollectionViewDiffableDataSource<Section, CategoryVM>!
    private var defaultSnapshot: NSDiffableDataSourceSnapshot<Section, CategoryVM> {
        let title = (self.title ?? "").uppercased()
        var categories = CategoryVM.defaultCategories
        categories.append(CategoryVM(name: "ALL \(title)"))
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, CategoryVM>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(categories, toSection: .category)
        return snapshot
    }
        
    // MARK: - Overridden methods
    
    override func loadView() {
        configurator.configure(categoriesViewController: self)
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        setupNavigationBar()
        presenter.viewDidLoad()
    }
    
    // MARK: - CategoriesView
    
    func display(title: String) {
        DispatchQueue.main.async {
            self.title = title.uppercased()
            // bug: title alpha is zero in iOS 16
            if #available(iOS 16.0, *) {
                self.navigationController?.navigationBar.setNeedsLayout()
            }
            // apply default snapshot with updated title
            self.dataSource.apply(self.defaultSnapshot)
        }
    }
    
    func displayLoading(categoriesCount: Int) {
        guard categoriesCount > 0 else { return }
        DispatchQueue.main.async {
            let emptyCategories = (1...categoriesCount).map { CategoryVM(name: String($0)) }
            var snapshot = self.dataSource.snapshot()
            snapshot.appendItems(emptyCategories, toSection: .family)
            self.dataSource.apply(snapshot)
        }
    }
    
    func display(categories: [CategoryVM]) {
        DispatchQueue.main.async {
            self.categories = categories
            var snapshot = self.defaultSnapshot
            snapshot.appendItems(categories, toSection: .family)
            self.dataSource.apply(snapshot)
        }
    }
    
    func displayError(title: String, message: String?) {
        DispatchQueue.main.async {
            print("ERROR: ", title)
        }
    }
    
    // MARK: - Private methods
    
    private func configureDataSource() {
        rootView.сollectionView.delegate = self
        let cellRegistration = UICollectionView.CellRegistration<CategoryViewCell, CategoryVM> {
            [weak self] (cell, indexPath, model) in
            guard let section = self?.rootView.getSectionKind(forSection: indexPath.section),
                  let self else { return }
            
            switch section {
            case .category:
                cell.configure(with: model)
            case .family:
                if indexPath.item < self.categories.count {
                    cell.configure(with: model)
                } else {
                    cell.startLoadingAnimation()
                }
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, CategoryVM>(collectionView: rootView.сollectionView, cellProvider: { сollectionView, indexPath, model in
            return сollectionView.dequeueConfiguredReusableCell(
                using: cellRegistration, for: indexPath, item: model)
        })
        
        // apply default snapshot
        dataSource.apply(defaultSnapshot)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark", tintColor: .appDarkGray, pointSize: 22, weight: .regular),
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped))
    }
    
    @objc private func closeButtonTapped() {
        presenter.closeButtonTapped()
    }
}

// MARK: - UICollectionViewDelegate

extension CategoriesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = rootView.getSectionKind(forSection: indexPath.section) else { fatalError() }
        
        switch section {
        case .category:
            
            switch indexPath.item {
            case 0: presenter.didTapMensProducts()
            case 1: presenter.didTapWomensProducts()
            case 2: presenter.didTapKidsProducts()
            case 3: presenter.didTapAllProducts()
            default: fatalError() }
            
        case .family:
            let family = categories[indexPath.item].name
            presenter.didSelect(productFamily: family)
        }
    }
}
