//
//  ProductsViewController.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import UIKit

class ProductsViewController: UIViewController {
    
    var configurator: ProductsConfigurator!
    var presenter: ProductsPresenter!
    var rootView: ProductsRootView!
    
    private var section: Sectionable!
    
    // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(productsViewController: self)
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
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        
        rootView.collectionView.register(ProductsViewCell.self,
            forCellWithReuseIdentifier: ProductsViewCell.reuseId)
        rootView.collectionView.register(HeaderReusableView.self,
            forSupplementaryViewOfKind: HeaderReusableView.elementKind,
            withReuseIdentifier: HeaderReusableView.reuseId)
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
        Task { await presenter.menuButtonTapped() }
    }
}

extension ProductsViewController: ProductsView {
    
    func display(title: String) {
        self.title = title
    }
    
    func display(productsSection: any Sectionable) {
        section = productsSection
        rootView.collectionView.reloadData()
    }
    
    func display(productItem: any Itemable, at index: Int) {
        section.insert(productItem, at: index)
        productItem.viewModel == nil
            ? rootView.collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
            : rootView.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
    
    func displayError(title: String, message: String?) {
        print("ERROR:", title)
    }
}

// MARK: - UICollectionViewDataSource

extension ProductsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.section?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsViewCell.reuseId, for: indexPath)
        let viewModel = section.items[indexPath.item].viewModel as? ProductCellViewModel
        (cell as? ProductsViewCell)?.viewModel = viewModel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: HeaderReusableView.elementKind,
            withReuseIdentifier: HeaderReusableView.reuseId, for: indexPath)
        (view as? HeaderReusableView)?.headerLabel.text = section?.header
        return view
    }
}

// MARK: - UICollectionViewDelegate

extension ProductsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Task { await presenter.didSelectItem(at: indexPath) }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.item == section.items.count - 1 else { return }
        Task { await presenter.willDisplayLastItem(at: indexPath.item) }
    }
}
