//
//  ProductDetailsViewController.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 18.09.2022.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    var configurator: ProductDetailsConfigurator!
    var presenter: ProductDetailsPresenter!
    var rootView: ProductDetailsRootView!
    
    private var viewModel: ProductDetailsViewModel! {
        didSet {
            rootView.nameLabel.text = viewModel.name
            rootView.imageData = viewModel.imageData
            rootView.colorSegments = viewModel.colors
            rootView.selectedColorSegment = viewModel.selectedColorIndex
            rootView.isProductInFavorite = viewModel.isInFavorite
            rootView.sizeLabel.text = viewModel.size
            rootView.geofitLabel.text = viewModel.geofit
            rootView.descriptionLabel.text = viewModel.description
            rootView.priceLabel.text = viewModel.price
            let title = viewModel.isInCart ? "SHOPPING BAG" : "ADD TO BAG"
            let color = viewModel.isInCart ? UIColor.appBlack : UIColor.appRed
            rootView.addToCartButtonTitle = title
            rootView.addToCartButtonColor = color
            rootView.showActivityIndicator = viewModel.imageData.count <= 1
        }
    }
    
    // MARK: - Initializers and overridden methods
    
    override func loadView() {
        configurator.configure(productDetailsViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        Task { await presenter.viewDidLoad() }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard viewModel != nil else { return }
        Task { await presenter.viewWillAppear() }
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        rootView.colorSegmentsDelegate = self
        rootView.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        rootView.addToCartButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        rootView.buyNowButton.addTarget(self, action: #selector(buyNowButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(cartButtonTapped))
    }
    
    @objc private func favoriteButtonTapped(_ sender: CheckboxButton) {
        Task { await presenter.favoriteButtonTapped(isFavorite: sender.isChecked) }
    }
    
    @objc private func addToCartButtonTapped() {
        Task {
            viewModel.isInCart == true
                ? await presenter.showCartButtonTapped()
                : await presenter.addToCartButtonTapped(productID: viewModel.productID)
        }
    }
    
    @objc private func buyNowButtonTapped() {
        Task { await presenter.buyNowButtonTapped(productID: viewModel.productID) }
    }
    
    @objc private func cartButtonTapped() {
        Task { await presenter.showCartButtonTapped() }
    }
}

extension ProductDetailsViewController: ProductDetailsView {
    
    func hideCartBadge() {
        navigationItem.rightBarButtonItem?.image = UIImage(
            systemName: "cart", pointSize: 19, weight: .semibold, paletteColors: [.appBlack])
    }
    
    func displayCartBadge() {
        navigationItem.rightBarButtonItem?.image = UIImage(
            named: "cart.badge", pointSize: 19, weight: .semibold, paletteColors: [.appRed, .appBlack])
    }
    
    func display(viewModel: ProductDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    func displayError(title: String, message: String?) {
        showAlert(title: title, message: message)
    }
}

extension ProductDetailsViewController: ColorSegmentedControlDelegate {
    
    func didSelectSegment(atIndex index: Int) {
        Task { await presenter.didSelectColorSegment(at: index) }
    }
}
