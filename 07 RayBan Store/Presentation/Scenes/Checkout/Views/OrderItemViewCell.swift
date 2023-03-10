//
//  OrderItemViewCell.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.03.2023.
//

import UIKit
import Stevia

protocol OrderItemViewModel {
    var productID: Int { get }
    var name: String { get }
    var price: String { get }
    var quantity: String { get }
    var imageData: Data { get }
}

class OrderItemViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .appLightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack.withAlphaComponent(0.9)
        label.font = .Oswald.medium
        label.numberOfLines = 2
        label.text = "NAME NAME NAME NAME"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack.withAlphaComponent(0.9)
        label.font = .Oswald.medium
        label.textAlignment = .right
        label.text = "$ 129.00"
        return label
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appDarkGray
        label.font = .Lato.medium
        label.textAlignment = .right
        label.text = "qty: 2"
        return label
    }()
    
    var viewModel: OrderItemViewModel? {
        didSet {
            guard let viewModel else { return }
            setImage(with: viewModel.imageData)
            nameLabel.text = viewModel.name
            priceLabel.text = viewModel.price
            quantityLabel.text = viewModel.quantity
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        addBorder(at: .top, color: .appGray, width: 0.5)
        addBorder(at: .bottom, color: .appGray, width: 0.5)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setImage(with data: Data) {
        DispatchQueue.global().async {
            guard let image = UIImage(data: data)?.preparingForDisplay() else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    
    private func configureLayout() {
        subviews(
            imageView,
            nameLabel,
            priceLabel,
            quantityLabel
        )
        
        imageView.left(0).top(0).bottom(0).heightEqualsWidth()
        nameLabel.top(8).Left == imageView.Right + 8
        priceLabel.top(8).right(16).Left == nameLabel.Right + 8
        quantityLabel.right(16).bottom(12)
        
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        priceLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
}
