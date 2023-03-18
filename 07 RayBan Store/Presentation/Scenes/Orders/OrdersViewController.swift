//
//  OrdersViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 11.03.2023.
//

import UIKit

class OrdersViewController: UIViewController {
    
    var configurator: OrdersConfigurator!
    var presenter: OrdersPresenter!
    var rootView: OrdersRootView!
    
    private var viewModels: [ViewModel] = []
    
    // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(ordersViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        Task { await presenter.viewDidLoad() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task { await presenter.viewWillAppear() }
    }
    
    private func setupViews() {
        rootView.сollectionView.delegate = self
        rootView.сollectionView.dataSource = self
        rootView.сollectionView.register(OrderItemsViewCell.self, forCellWithReuseIdentifier: OrderItemsViewCell.reuseId)
        
        rootView.activityIndicator.startAnimating()
    }
    
}

extension OrdersViewController: OrdersView {
    
    func display(title: String) {
        self.title = title
    }
    
    func display(viewModels: [ViewModel]) {
        self.viewModels = viewModels
        rootView.сollectionView.reloadData()
        
        rootView.activityIndicator.stopAnimating()
        viewModels.isEmpty
            ? rootView.emptyStateView.show()
            : rootView.emptyStateView.hide()
    }
    
    func displayError(title: String, message: String?) {
        showAlert(title: title, message: message, buttonTitle: "OK")
    }
}

extension OrdersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(OrderItemsViewCell.self, for: indexPath) { cell in
            cell.viewModel = viewModels[indexPath.item]
        }
    }
}

extension OrdersViewController: UICollectionViewDelegate {
    
}
