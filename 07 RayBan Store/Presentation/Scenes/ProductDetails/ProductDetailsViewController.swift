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
        rootView.productDetailsCollectionView.register(ProductImagesViewCell.self,
                           forCellWithReuseIdentifier: ProductImagesViewCell.identifier)
        rootView.productDetailsCollectionView.register(ProductDescriptionViewCell.self,
                           forCellWithReuseIdentifier: ProductDescriptionViewCell.identifier)
        rootView.productDetailsCollectionView.register(ProductPropertyViewCell.self,
                           forCellWithReuseIdentifier: ProductPropertyViewCell.identifier)
        rootView.productDetailsCollectionView.register(ProductDetailsViewCell.self,
                           forCellWithReuseIdentifier: ProductDetailsViewCell.identifier)
        rootView.productDetailsCollectionView.register(ProductActionsViewCell.self,
                           forCellWithReuseIdentifier: ProductActionsViewCell.identifier)
        
        rootView.productDetailsCollectionView.dataSource = self
        rootView.productDetailsCollectionView.delegate = self
    }
    
    private func setupNavigationBar() {
        let cartButton = UIButton.buttonWithSFImage(name: "cart", color: UIColor.appBlack, size: 17, weight: .semibold)
        
        cartButton.addAction(UIAction(handler: { [weak self] _ in
            self?.presenter.cartButtonTapped()
        }), for: .touchUpInside)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: cartButton)
        ]
    }
}

extension ProductDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        rootView.getNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = rootView.getSectionKind(forSection: section) else { fatalError() }
        switch section {
        case .images:      return viewModel?.images.count ?? 0
        case .description: return 1
        case .property:    return 2
        case .details:     return 1
        case .actions:     return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = rootView.getSectionKind(forSection: indexPath.section) else { fatalError() }
        
        switch section {
        case .images:
            
            let cell: ProductImagesViewCell = getReusableCell(from: collectionView, forIndexPath: indexPath)
            if let data = viewModel?.images[indexPath.item], let image = UIImage(data: data) {
                cell.setImage(image: image)
            }
            
            return cell
        case .description:
            
            let cell: ProductDescriptionViewCell = getReusableCell(from: collectionView, forIndexPath: indexPath)
            cell.setTitle(title: viewModel?.title)
            cell.setColors(number: 3)
            cell.colorsSegmentedControl.removeAllSegments()
            cell.colorsSegmentedControl.insertSegment(withTitle: "RED", at: 0, animated: false)
            cell.colorsSegmentedControl.insertSegment(withTitle: "GREEN", at: 1, animated: false)
            cell.colorsSegmentedControl.insertSegment(withTitle: "BLUE", at: 2, animated: false)
            cell.colorsSegmentedControl.selectedSegmentIndex = 0
            
            return cell
        case .property:
            
            let cell: ProductPropertyViewCell = getReusableCell(from: collectionView, forIndexPath: indexPath)
            if indexPath.item == 0 {
                cell.setText("CATEGORY", value: viewModel?.category ?? "")
            } else {
                cell.setText("ID", value: "8976234593")
            }
            
            return cell
        case .details:
            
            let cell: ProductDetailsViewCell = getReusableCell(from: collectionView, forIndexPath: indexPath)
            cell.setDetails(text: viewModel?.details)
            
            return cell
        case .actions:
            
            let cell: ProductActionsViewCell = getReusableCell(from: collectionView, forIndexPath: indexPath)
            if let price = viewModel?.price {
                cell.setPrice(price, withColor: UIColor.appRed)
            }
            
            return cell
        }
    }
    
    // MARK: - Private methods
    
    private func getReusableCell<T: UICollectionViewCell>(from collectionView: UICollectionView, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T
        else { fatalError() }
        return cell
    }
}

extension ProductDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell is ProductActionsViewCell {
            rootView.trailingBuyButton.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell is ProductActionsViewCell {
            rootView.trailingBuyButton.isHidden = false
        }
    }
}
