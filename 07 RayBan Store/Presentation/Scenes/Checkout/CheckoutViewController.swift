//
//  CheckoutViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.03.2023.
//

import UIKit

class CheckoutViewController: UIViewController {
    
    var configurator: CheckoutConfigurator!
    var presenter: CheckoutPresenter!
    var rootView: CheckoutRootView!
    
    private var itemsSection: Sectionable!
    private var orderDetails: OrderDetailsViewModel!
    private var deliveryInfo: DeliveryInfoViewModel!
    
    // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(checkoutViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        Task { await presenter.viewDidLoad() }
    }
    
    private func setupViews() {
        hideKeyboardWhenTappedAround()
        observeKeyboardNotification(for: rootView.сollectionView.bottomConstraint, adjustOffsetFor: rootView.сollectionView)
        
        rootView.сollectionView.delegate = self
        rootView.сollectionView.dataSource = self
        rootView.сollectionView.register(OrderItemViewCell.self, forCellWithReuseIdentifier: OrderItemViewCell.reuseId)
        rootView.сollectionView.register(OrderDetailsViewCell.self, forCellWithReuseIdentifier: OrderDetailsViewCell.reuseId)
        rootView.сollectionView.register(DeliveryInfoViewCell.self, forCellWithReuseIdentifier: DeliveryInfoViewCell.reuseId)
    }
}

extension CheckoutViewController: CheckoutView {
    
    func display(title: String) {
        self.title = title
    }
    
    func display(itemsSection: any Sectionable) {
        self.itemsSection = itemsSection
        rootView.сollectionView.reloadData()
    }
    
    func display(orderDetails: OrderDetailsViewModel) {
        self.orderDetails = orderDetails
        rootView.сollectionView.reconfigureItems(at: [IndexPath(item: 0, section: 1)])
    }
    
    func display(deliveryInfo: DeliveryInfoViewModel) {
        self.deliveryInfo = deliveryInfo
        rootView.сollectionView.reconfigureItems(at: [IndexPath(item: 0, section: 2)])
    }
    
    func displayError(title: String, message: String?) {
        showAlert(title: title, message: message, buttonTitle: "OK")
    }
}

extension CheckoutViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        itemsSection?.items.count == 0 ? 0 : 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? itemsSection?.items.count ?? 0 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return collectionView.dequeueReusableCell(OrderItemViewCell.self, for: indexPath) { cell in
                cell.viewModel = itemsSection.items[indexPath.item].viewModel as? OrderItemViewModel
            }
        case 1:
            return collectionView.dequeueReusableCell(OrderDetailsViewCell.self, for: indexPath) { cell in
                cell.viewModel = orderDetails
            }
        default:
            return collectionView.dequeueReusableCell(DeliveryInfoViewCell.self, for: indexPath) { cell in
                cell.viewModel = deliveryInfo
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        false
    }
}

extension CheckoutViewController: UICollectionViewDelegate {
    
}
