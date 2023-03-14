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
    private var cartSummary: CartSummaryViewModel?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { await presenter.viewWillAppear() }
    }
    
    private func setupCollectionView() {
        rootView.сollectionView.delegate = self
        rootView.сollectionView.dataSource = self
        rootView.сollectionView.register(CartItemViewCell.self, forCellWithReuseIdentifier: CartItemViewCell.reuseId)
        rootView.сollectionView.register(CartSummaryViewCell.self, forCellWithReuseIdentifier: CartSummaryViewCell.reuseId)
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
    
    func display(cartSummary: CartSummaryViewModel) {
        self.cartSummary = cartSummary
        rootView.сollectionView.reconfigureItems(at: [IndexPath(item: 0, section: 1)])
    }
    
    func displayError(title: String, message: String?) {
        showAlert(title: title, message: message)
    }
}

extension CartViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        itemsSection?.items.count == 0 ? 0 : 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? itemsSection?.items.count ?? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return collectionView.dequeueReusableCell(CartItemViewCell.self, for: indexPath) { cell in
                cell.viewModel = itemsSection.items[indexPath.item].viewModel as? CartItemViewModel
            }
        default:
            return collectionView.dequeueReusableCell(CartSummaryViewCell.self, for: indexPath) { cell in
                cell.viewModel = cartSummary
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        indexPath.section == 0
    }
}

extension CartViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = itemsSection.items[indexPath.item]
        Task { await presenter.didSelectItem(item) }
    }
}
