//
//  CartItemViewCell.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 25.02.2023.
//

import UIKit
import Stevia

protocol CartItemViewModel {
    var productID: Int { get }
    var quantity: Int { get }
    var name: String { get }
    var price: String { get }
    var frame: String { get }
    var lense: String { get }
    var size: String { get }
    var imageData: Data { get }
    var itemAmountDidChange: (ProductID, Int) async -> Void { get }
    var deleteItemButtonTapped: (ProductID) async -> Void { get }
}

class CartItemViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .appLightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Oswald.medium
        label.numberOfLines = 2
        label.text = "NAME NAME NAME NAME"
        return label
    }()
    
    private let frameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.regular.withSize(13)
        label.text = "Frame color: gold"
        return label
    }()
    
    private let lenseLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.regular.withSize(13)
        label.text = "Lense colro: green"
        return label
    }()
    
    private let sizeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.regular.withSize(13)
        label.text = "Size: Standart"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Oswald.medium.withSize(18)
        label.textAlignment = .right
        label.text = "$ 129.00"
        return label
    }()
    
    private let stepper = QuantityStepper()
    
    var viewModel: CartItemViewModel? {
        didSet {
            guard let viewModel else { return }
            setImage(with: viewModel.imageData)
            nameLabel.text = viewModel.name
            frameLabel.text = viewModel.frame
            lenseLabel.text = viewModel.lense
            sizeLabel.text = viewModel.size
            priceLabel.text = viewModel.price
            stepper.value = viewModel.quantity
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        addBorder(at: .top, color: .appGray, width: 0.5)
        addBorder(at: .bottom, color: .appGray, width: 0.5)
        stepper.addTarget(self, action: #selector(stepperValueChanged), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    @objc private func stepperValueChanged(_ sender: QuantityStepper) {
        guard let viewModel else { return }
        if sender.value == 0 {
            Task { await viewModel.deleteItemButtonTapped(viewModel.productID) }
        } else {
            Task { await viewModel.itemAmountDidChange(viewModel.productID, sender.value) }
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
    
    private func configureLayout() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        
        [frameLabel, lenseLabel, sizeLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        subviews(
            imageView,
            nameLabel,
            stackView,
            priceLabel,
            stepper
        )
        
        imageView.left(0).top(0).bottom(0).heightEqualsWidth()
        nameLabel.top(8).Left == imageView.Right + 8
        priceLabel.top(8).right(16).Left == nameLabel.Right + 8
        stackView.Left == imageView.Right + 8
        stackView.bottom(>=8).Top == nameLabel.Bottom + 8
        stepper.right(8).bottom(16).Left == stackView.Right + 8
        
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        priceLabel.setContentHuggingPriority(.required, for: .horizontal)
    }
}
