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
    func displayError(title: String, message: String?)
    func display(viewModels: [ProductFamilyVM])
}

class CategoriesViewController: UIViewController, CategoriesView {
    
    var configurator: CategoriesConfigurator!
    var presenter: CategoriesPresenter!
    var rootView: CategoriesRootView!
    
    private var viewModels: [ProductFamilyVM] = []
        
    // MARK: - Overridden methods
    
    override func loadView() {
        configurator.configure(categoriesViewController: self)
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectinView()
        presenter.viewDidLoad()
    }
    
    // MARK: - CategoriesView
    
    func display(title: String) {
        DispatchQueue.main.async { [weak self] in
            self?.title = title.uppercased()
            // bug: title alpha is zero in iOS 16
            if #available(iOS 16.0, *) {
                self?.navigationController?.navigationBar.setNeedsLayout()
            }
        }
    }
    
    func displayError(title: String, message: String?) {
        DispatchQueue.main.async {
            print("ERROR: ", title)
        }
    }
    
    func display(viewModels: [ProductFamilyVM]) {
        self.viewModels = viewModels
        DispatchQueue.main.async { [weak self] in
            self?.rootView.сollectionView.reloadData()
        }
    }
     
    // MARK: - Private methods
    
    private func setupCollectinView() {
        rootView.сollectionView.register(CategoryViewCell.self, forCellWithReuseIdentifier: CategoryViewCell.reuseId)
        rootView.сollectionView.delegate = self
        rootView.сollectionView.dataSource = self
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

// MARK: - UICollectionViewDataSource

extension CategoriesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        rootView.getNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = rootView.getSectionKind(forSection: section) else { fatalError() }
        switch section {
        case .category: return 4
        case .family:   return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.reuseId, for: indexPath)
        
        if let cell = cell as? CategoryViewCell {
            guard let section = rootView.getSectionKind(forSection: indexPath.section) else { fatalError() }
            
            switch section {
            case .category:
                
                switch indexPath.item {
                case 0: cell.setTitle(title: "men")
                case 1: cell.setTitle(title: "women")
                case 2: cell.setTitle(title: "kids")
                case 3: cell.setTitle(title: "all " + (title ?? ""))
                default: fatalError() }
                
            case .family:
                
                let model = viewModels[indexPath.item]
                let title = model.productFamily
                let image = UIImage(data: model.imageData ?? Data())
                cell.setTitle(title: title)
                cell.setImage(image: image)
            }
        }
        
        return cell
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
            let family = viewModels[indexPath.item].productFamily
            presenter.didSelect(productFamily: family)
        }
    }
}
