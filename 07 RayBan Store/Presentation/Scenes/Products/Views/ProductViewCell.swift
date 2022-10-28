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
        image.backgroundColor = UIColor.appLightGray
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
        label.textColor = UIColor.appBlack
        label.font = UIFont.Oswald.regular.withSize(14)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.medium
        label.textColor = UIColor.appBlack
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = "unknown"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Lato.bold
        label.textColor = UIColor.appBlack
        label.text = "unknown"
        return label
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.appBlack
        button.titleLabel?.font = UIFont.Oswald.bold
        button.setTitleColor(.white, for: .normal)
        button.setTitle("ADD TO BAG", for: .normal)
        return button
    }()
    
    private var imageShimmerView = ShimmerView()
    private var nameShimmerView = ShimmerView()
    private var priceShimmerView = ShimmerView()
    private var buttonShimmerView = ShimmerView()
    
    // MARK: - Initializers and overridden methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration methods
    
    func configure(with product: ProductVM) {
        stopAnimating()
        setImage(product.images.first)
        newLabel.isHidden = false
        nameLabel.text = product.nameLabel
        colorsLabel.text = product.colorsLabel
        priceLabel.text = product.variations.first?.priceLabel
    }
    
    private func setImage(_ image: UIImage?) {
        self.imageView.image = nil
        DispatchQueue.global().async {
            guard let image = image?.preparingForDisplay() else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    func startLoadingAnimation() {
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
    
    // MARK: - Private methods
    
    private func configureLayout() {
        subviews(
            imageView.subviews(
                newLabel,
                colorsLabel,
                imageShimmerView),
            nameLabel.subviews(
                nameShimmerView),
            priceLabel.subviews(
                priceShimmerView),
            buyButton.subviews(
                buttonShimmerView)
        )
        
        let padding = 0.05 * frame.width
        
        imageView.width(100%).top(0)//.heightEqualsWidth()
        newLabel.right(padding).top(padding)
        colorsLabel.left(padding).bottom(padding)
        nameLabel.width(90%).centerHorizontally().Top == imageView.Bottom + padding
        priceLabel.width(90%).centerHorizontally().Top == nameLabel.Bottom + padding
        buyButton.width(100%).height(40).bottom(padding).Top == priceLabel.Bottom + padding
        
        imageShimmerView.fillContainer()
        nameShimmerView.fillContainer()
        priceShimmerView.fillContainer()
        buttonShimmerView.fillContainer()
    }
}
