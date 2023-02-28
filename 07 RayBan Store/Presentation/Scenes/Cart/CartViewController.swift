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
    
    private var section: Sectionable!
    
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
        rootView.сollectionView.dataSource = self
        rootView.сollectionView.delegate = self
        
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
        section = cartSection
        rootView.сollectionView.reloadData()
    }
    
    func displayError(title: String, message: String?) {
        
    }
}

extension CartViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        section?.items.count == 0 ? 0 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? self.section?.items.count ?? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        
        switch indexPath.section {
        case 0:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartItemViewCell.reuseId, for: indexPath)
            (cell as? CartItemViewCell)?.viewModel = section.items[indexPath.item].viewModel as? CartItemCellViewModel
        case 1:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShippingViewCell.reuseId, for: indexPath)
        default:
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: SummaryViewCell.reuseId, for: indexPath)
        }
        
        return cell
    }
}

extension CartViewController: UICollectionViewDelegate {
    
}
