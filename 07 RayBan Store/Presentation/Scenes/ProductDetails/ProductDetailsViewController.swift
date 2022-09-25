//
//  ProductDetailsViewController.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 18.09.2022.
//

import UIKit

class ProductDetailsViewController: UIViewController, ProductDetailsView {
    
    var configurator: ProductDetailsConfigurator!
    var presenter: ProductDetailsPresenter!
    var rootView: ProductDetailsRootView!
    
    private var viewModel: ProductViewModel?
        
    override func loadView() {
        configurator.configure(productDetailsViewController: self)
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectinView()
        setupNavigationBar()
        presenter.viewDidLoad()
    }
    
    func display(viewModel: ProductViewModel) {
        self.viewModel = viewModel
//        print(viewModel.images) 
        rootView.setPriceForTrailingButton(price: viewModel.price)
        rootView.productDetailsCollectionView.reloadData()
    }
    
    func displayError(title: String, message: String?) {
        print("ERROR: ", title)
    }
    
    private func setupCollectinView() {
        rootView.productDetailsCollectionView.register(ProductImagesCollectionViewCell.self,
                           forCellWithReuseIdentifier: ProductImagesCollectionViewCell.cellIdentifier)
        rootView.productDetailsCollectionView.register(ProductDescriptionCollectionViewCell.self,
                           forCellWithReuseIdentifier: ProductDescriptionCollectionViewCell.cellIdentifier)
        rootView.productDetailsCollectionView.register(ProductPropertyCollectionViewCell.self,
                           forCellWithReuseIdentifier: ProductPropertyCollectionViewCell.cellIdentifier)
        rootView.productDetailsCollectionView.register(ProductDetailsCollectionViewCell.self,
                           forCellWithReuseIdentifier: ProductDetailsCollectionViewCell.cellIdentifier)
        rootView.productDetailsCollectionView.register(ProductActionsCollectionViewCell.self,
                           forCellWithReuseIdentifier: ProductActionsCollectionViewCell.cellIdentifier)
        
        rootView.productDetailsCollectionView.dataSource = self
        rootView.productDetailsCollectionView.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.Oswald.medium.withSize(0.1)]
        navigationController?.navigationBar.subviews.filter({ $0 is UIImageView }).first?.removeFromSuperview()
    }
}

extension ProductDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        rootView.getNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = rootView.getSectionKind(forSection: section) else { fatalError() }
        switch section {
        case .images: return viewModel?.images.count ?? 0
        case .description: return 1
        case .property: return 2
        case .details: return 1
        case .actions: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = rootView.getSectionKind(forSection: indexPath.section) else { fatalError() }
        
        switch section {
        case .images:
            let cell: ProductImagesCollectionViewCell = getReusableCell(from: collectionView, forIndexPath: indexPath)
            if let data = viewModel?.images[indexPath.item], let image = UIImage(data: data) {
                cell.imageView.image = image
            }
            return cell
        case .description:
            let cell: ProductDescriptionCollectionViewCell = getReusableCell(from: collectionView, forIndexPath: indexPath)
            cell.titleLabel.text = viewModel?.title
            cell.setNumberOfColors(3)
            cell.colorsSegmentedControl.removeAllSegments()
            cell.colorsSegmentedControl.insertSegment(withTitle: "RED", at: 0, animated: false)
            cell.colorsSegmentedControl.insertSegment(withTitle: "GREEN", at: 1, animated: false)
            cell.colorsSegmentedControl.insertSegment(withTitle: "BLUE", at: 2, animated: false)
            cell.colorsSegmentedControl.selectedSegmentIndex = 0
            return cell
        case .property:
            let cell: ProductPropertyCollectionViewCell = getReusableCell(from: collectionView, forIndexPath: indexPath)
            if indexPath.item == 0 {
                cell.setText("CATEGORY", value: viewModel?.category ?? "")
            } else {
                cell.setText("ID", value: "8976234593")
            }
            return cell
        case .details:
            let cell: ProductDetailsCollectionViewCell = getReusableCell(from: collectionView, forIndexPath: indexPath)
            cell.productDetailsLabel.text = (viewModel?.details ?? "") + (viewModel?.details ?? "")
            return cell
        case .actions:
            let cell: ProductActionsCollectionViewCell = getReusableCell(from: collectionView, forIndexPath: indexPath)
            if let price = viewModel?.price {
                cell.setPrice(price, withColor: UIColor.appRed)
            }
            return cell
        }
    }
    
    // MARK: - Private methods
    
    private func getReusableCell<T: UICollectionViewCell>(from collectionView: UICollectionView, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.cellIdentifier, for: indexPath) as? T
        else { fatalError() }
        return cell
    }
}

extension ProductDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell is ProductActionsCollectionViewCell {
            rootView.trailingBuyButton.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell is ProductActionsCollectionViewCell {
            rootView.trailingBuyButton.isHidden = false
        }
    }
}
