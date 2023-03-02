//
//  CartViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 25.02.2023.
//

import UIKit

class CartViewController: UIViewController {
    
    var configurator: CartConfigurator!
    var presenter: CartPresenter!
    var rootView: CartRootView!
    
    private var itemsSection: Sectionable!
    private var shippingMethods: [ShippingMethodModel] = []
    
    // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(cartViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        Task { await presenter.viewDidLoad() }
    }
    
    private func setupCollectionView() {
        rootView.сollectionView.delegate = self
        rootView.сollectionView.dataSource = self
        rootView.сollectionView.register(CartItemViewCell.self, forCellWithReuseIdentifier: CartItemViewCell.reuseId)
        rootView.сollectionView.register(ShippingViewCell.self, forCellWithReuseIdentifier: ShippingViewCell.reuseId)
        rootView.сollectionView.register(SummaryViewCell.self, forCellWithReuseIdentifier: SummaryViewCell.reuseId)
    }
}

extension CartViewController: CartView {
    
    func display(title: String) {
        self.title = title
    }
    
    func display(cartSection: any Sectionable) {
        self.itemsSection = cartSection
        rootView.сollectionView.reloadData()
    }
    
    func display(shippingMethods: [ShippingMethodModel]) {
        self.shippingMethods = shippingMethods
        rootView.сollectionView.reloadData()
    }
    
    func displayError(title: String, message: String?) {
        showAlert(title: title, message: message, buttonTitle: "OK")
    }
}

extension CartViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        itemsSection?.items.count == 0 ? 0 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? itemsSection?.items.count ?? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        switch indexPath.section {
        case 0:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartItemViewCell.reuseId, for: indexPath)
            (cell as? CartItemViewCell)?.viewModel = itemsSection.items[indexPath.item].viewModel as? CartItemCellViewModel
        case 1:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShippingViewCell.reuseId, for: indexPath)
            (cell as? ShippingViewCell)?.shippingMethods = shippingMethods
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: SummaryViewCell.reuseId, for: indexPath)
        }
        
        return cell
    }
}

extension CartViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = itemsSection.items[indexPath.item]
        Task { await presenter.didSelectItem(item) }
    }
}
