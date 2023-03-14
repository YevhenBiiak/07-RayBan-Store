//
//  CategoriesViewController.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.09.2022.
//

import UIKit

@MainActor
protocol CategoriesRouter {
    func returnToProducts()
    func presentAllProducts()
    func presentProducts(gender: Product.Gender)
    func presentProducts(style: Product.Style)
}

@MainActor
protocol CategoriesConfigurator {
    func configure(categoriesViewController: CategoriesViewController)
}

protocol CategoriesPresenter {
    func viewDidLoad() async
    func closeButtonTapped() async
    func didSelectHeader(at index: Int) async
    func didSelectProduct(at index: Int) async
    func willDisplayLastProduct(at index: Int) async
}

@MainActor
protocol CategoriesView: AnyObject {
    func display(title: String)
    func display(headerSection: any Sectionable)
    func display(productSection: any Sectionable)
    func display(productItem: any Itemable, at index: Int)
    func displayError(title: String, message: String?)
}

class CategoriesViewController: UIViewController {
    
    var configurator: CategoriesConfigurator!
    var presenter: CategoriesPresenter!
    var rootView: CategoriesRootView!
    
    private var headerSection: Sectionable!
    private var productSection: Sectionable!
    
    // MARK: - Overridden methods
    
    override func loadView() {
        configurator.configure(categoriesViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationBar()
        Task { await presenter.viewDidLoad() }
    }
    
    // MARK: - Private methods
    
    private func setupCollectionView() {
        rootView.сollectionView.dataSource = self
        rootView.сollectionView.delegate = self
        
        rootView.сollectionView.register(CategoryViewCell.self,
            forCellWithReuseIdentifier: CategoryViewCell.reuseId)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark", pointSize: 22, weight: .medium, paletteColors: [.appDarkGray]),
            style: .plain,
            target: self,
            action: #selector(closeButtonTapped))
    }
    
    @objc private func closeButtonTapped() {
        Task { await presenter.closeButtonTapped() }
    }
}
  
// MARK: - CategoriesView

extension CategoriesViewController: CategoriesView {
    
    func display(title: String) {
        self.title = title.uppercased()
    }
    
    func display(headerSection: Sectionable) {
        self.headerSection = headerSection
        rootView.сollectionView.reloadData()
    }
    
    func display(productSection: Sectionable) {
        self.productSection = productSection
        self.rootView.сollectionView.reloadData()
    }
    
    func display(productItem: any Itemable, at index: Int) {
        productSection.insert(productItem, at: index)
        rootView.сollectionView.reloadItems(at: [IndexPath(item: index, section: 1)])
    }
    
    func displayError(title: String, message: String?) {
        showAlert(title: title, message: message)
    }
}

// MARK: - UICollectionViewDataSource

extension CategoriesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        [headerSection, productSection].compactMap({$0}).count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? headerSection?.items.count ?? 0
                            : productSection?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.reuseId, for: indexPath)
        let viewModel = indexPath.section == 0
            ? headerSection.items[indexPath.item].viewModel
            : productSection.items[indexPath.item].viewModel
        
        (cell as? CategoryViewCell)?.viewModel = viewModel as? CategoryCellViewModel
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CategoriesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            Task { await presenter.didSelectHeader(at: indexPath.item) }
        case 1:
            guard productSection.items[indexPath.item].viewModel != nil else { return }
            Task { await presenter.didSelectProduct(at: indexPath.item) }
        default: break }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let productSection, indexPath.section == 1,
              indexPath.item == productSection.items.count - 1
        else { return }
        
        Task { await presenter.willDisplayLastProduct(at: indexPath.item) }
    }
}
