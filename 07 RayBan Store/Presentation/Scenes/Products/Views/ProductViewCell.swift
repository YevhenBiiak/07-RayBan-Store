//
//  ProductViewCell.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import UIKit
import Stevia

class ProductsViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .appLightGray
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let newLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.regular
        label.textColor = .red
        label.isHidden = true
        label.text = "NEW"
        return label
    }()
    
    private let colorsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = UIFont.Oswald.regular.withSize(14)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.medium
        label.textColor = .appBlack
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "unknown"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Lato.bold
        label.textColor = .appBlack
        label.text = "unknown"
        return label
    }()
    
    private let cartButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.Oswald.bold
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private var imageShimmerView = ShimmerView()
    private var nameShimmerView = ShimmerView()
    private var priceShimmerView = ShimmerView()
    private var buttonShimmerView = ShimmerView()
    
    var viewModel: ProductCellViewModel? {
        didSet {
            guard let viewModel else { return startAnimation() }
            setImage(with: viewModel.imageData)
            newLabel.isHidden = viewModel.isNew
            nameLabel.text = viewModel.name
            colorsLabel.text = viewModel.colors
            priceLabel.text = viewModel.price
            let title = viewModel.isInCart ? "SHOPPING BAG" : "ADD TO BAG"
            let color = viewModel.isInCart ? UIColor.appRed : UIColor.appBlack
            cartButton.setTitle(title, for: .normal)
            cartButton.backgroundColor = color
            stopAnimating()
        }
    }
    
    // MARK: - Initializers and overridden methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        cartButton.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Private methods
    
    @objc private func cartButtonTapped() {
        guard let viewModel else { return }
        if viewModel.isInCart == true {
            Task {  await viewModel.cartButtonTapped() }
        } else {
            Task {  await viewModel.addButtonTapped(viewModel) }
        }
    }
    
    private func setImage(with data: Data) {
        DispatchQueue.global().async {
            guard let image = UIImage(data: data)?.preparingForDisplay() else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    private func startAnimation() {
        imageShimmerView.startShimmerAnimating()
        nameShimmerView.startShimmerAnimating()
        priceShimmerView.startShimmerAnimating()
        buttonShimmerView.startShimmerAnimating()
    }
    
    private func stopAnimating() {
        imageShimmerView.stopShimmerAnimating()
        nameShimmerView.stopShimmerAnimating()
        priceShimmerView.stopShimmerAnimating()
        buttonShimmerView.stopShimmerAnimating()
    }
    
    private func configureLayout() {
        subviews(
            imageView.subviews(
                newLabel,
                colorsLabel),
            nameLabel,
            priceLabel,
            cartButton
        )
        
        let padding = 0.05 * frame.width
        
        imageView.width(100%).top(0)//.heightEqualsWidth()
        newLabel.right(padding).top(padding)
        colorsLabel.left(padding).bottom(padding)
        nameLabel.width(90%).centerHorizontally().Top == imageView.Bottom + padding
        priceLabel.width(90%).centerHorizontally().Top == nameLabel.Bottom + padding
        cartButton.width(100%).height(40).bottom(padding).Top == priceLabel.Bottom + padding
        
        // configure shummer views
        imageView.subviews(imageShimmerView)
        nameLabel.subviews(nameShimmerView)
        priceLabel.subviews(priceShimmerView)
        cartButton.subviews(buttonShimmerView)
        
        imageShimmerView.fillContainer()
        nameShimmerView.fillContainer()
        priceShimmerView.fillContainer()
        buttonShimmerView.fillContainer()
    }
}
