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
    
    private var viewModel: ProductDetailsViewModel! {
        didSet {
            rootView.nameLabel.text = viewModel.name
            rootView.imageData = viewModel.imageData
            rootView.colorSegments = viewModel.colors
            rootView.selectedColorSegment = viewModel.selectedColorIndex
            rootView.sizeLabel.text = viewModel.size
            rootView.geofitLabel.text = viewModel.geofit
            rootView.productDetailsLabel.text = viewModel.details
            rootView.priceLabel.text = viewModel.price
        }
    }
    
    override func loadView() {
        configurator.configure(productDetailsViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        Task { await presenter.viewDidLoad() }
    }
    
    func display(viewModel: ProductDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    func displayError(title: String, message: String?) {
        print("ERROR: ", title)
    }
    
    private func setupViews() {
        rootView.colorSegmentsDelegate = self
        
        // add BarButtonItem to rightBarButtonItems
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "cart", tintColor: .appBlack, pointSize: 19, weight: .semibold),
            style: .plain,
            target: self,
            action: #selector(cartButtonTapped))
    }
    
    @objc private func cartButtonTapped() {
        Task { await presenter.cartButtonTapped() }
    }
}

extension ProductDetailsViewController: ColorSegmentedControlDelegate {
    
    func didSelectSegment(atIndex index: Int) {
        Task { await presenter.didSelectColorSegment(at: index) }
    }
}
