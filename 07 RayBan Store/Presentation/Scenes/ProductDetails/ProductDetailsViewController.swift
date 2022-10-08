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
    
    private var product: ProductVM?
    private var currentProductVariant: ProductVariantVM?
        
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
    
    func display(product: ProductVM) {
        // print(product.images)
        DispatchQueue.main.async { [weak self] in
        self?.product = product
            if self?.currentProductVariant == nil {
                self?.currentProductVariant = product.variations.first
        }
        
            self?.updateView()
        }
    }
    
    func displayError(title: String, message: String?) {
        print("ERROR: ", title)
    }
    
    private func setupCollectinView() {
        rootView.collectionView.register(ProductImagesViewCell.self,
                           forCellWithReuseIdentifier: ProductImagesViewCell.reuseId)
        rootView.collectionView.register(ProductDescriptionViewCell.self,
                           forCellWithReuseIdentifier: ProductDescriptionViewCell.reuseId)
        rootView.collectionView.register(ProductPropertyViewCell.self,
                           forCellWithReuseIdentifier: ProductPropertyViewCell.reuseId)
        rootView.collectionView.register(ProductDetailsViewCell.self,
                           forCellWithReuseIdentifier: ProductDetailsViewCell.reuseId)
        rootView.collectionView.register(ProductActionsViewCell.self,
                           forCellWithReuseIdentifier: ProductActionsViewCell.reuseId)
        
        rootView.collectionView.dataSource = self
        rootView.collectionView.delegate = self
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
    
    private func updateView() {
        if let price = currentProductVariant?.price {
            rootView.setPriceForTrailingButton(price: price)
        }
        rootView.collectionView.reloadData()
    }
}

extension ProductDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        rootView.getNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = rootView.getSectionKind(forSection: section), let product
        else { return 0 }

        switch section {
        case .images:      print("numberOfItemsInSection", product.images.count); return product.images.count
        case .description: return 1
        case .property:    return 2 // size and geofit
        case .details:     return 1
        case .actions:     return 1 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = rootView.getSectionKind(forSection: indexPath.section) else { fatalError() }
        
        switch section {
        case .images:      return configuredImagesCell(from: collectionView, forIndexPath: indexPath)
        case .description: return configuredDescriptionCell(from: collectionView, forIndexPath: indexPath)
        case .property:    return configuredPropertyCell(from: collectionView, forIndexPath: indexPath)
        case .details:     return configuredDetailsCell(from: collectionView, forIndexPath: indexPath)
        case .actions:     return configuredActionsCell(from: collectionView, forIndexPath: indexPath) }
    }
    
    // MARK: - Private methods
    
    private func getReusableCell<T: UICollectionViewCell>(from collectionView: UICollectionView, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.reuseId, for: indexPath) as? T
        else { fatalError() }
        return cell
    }
    
    private func configuredImagesCell(from collectionView: UICollectionView, forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductImagesViewCell = getReusableCell(from: collectionView, forIndexPath: indexPath)
        
        print(indexPath.item)
        
        if let data = product?.images[indexPath.item], let image = UIImage(data: data) {
            cell.setImage(image: image)
        }
        return cell
    }
    
    private func configuredDescriptionCell(from collectionView: UICollectionView, forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductDescriptionViewCell = getReusableCell(from: collectionView, forIndexPath: indexPath)
        cell.setTitle(title: product?.name)
        cell.setColors(number: product?.variations.count)
        
        cell.removeAllColorSegments()
        for (i, variant) in (product?.variations ?? []).enumerated() {
            cell.insertColorSegment(at: i, title: variant.color, animated: false)
        }
        
        cell.setSelectedSegmentIndex(0)

        for (i, variant) in (product?.variations ?? []).enumerated() where variant.color == currentProductVariant?.color {
            cell.setSelectedSegmentIndex(i)
        }
        return cell
    }
    
    private func configuredPropertyCell(from collectionView: UICollectionView, forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductPropertyViewCell = getReusableCell(from: collectionView, forIndexPath: indexPath)
        
        switch indexPath.item {
        case 0: cell.configure(title: "size", value: product?.size)
        case 1: cell.configure(title: "geofit", value: product?.geofit)
        default: fatalError("Wrong number of properties") }
        
        return cell
    }
    
    private func configuredDetailsCell(from collectionView: UICollectionView, forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductDetailsViewCell = getReusableCell(from: collectionView, forIndexPath: indexPath)
        cell.setDetails(text: product?.details)
        
        return cell
    }
    
    private func configuredActionsCell(from collectionView: UICollectionView, forIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductActionsViewCell = getReusableCell(from: collectionView, forIndexPath: indexPath)
        if let price = currentProductVariant?.price {
            cell.setPrice(price, withColor: UIColor.appRed)
        }
        
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
