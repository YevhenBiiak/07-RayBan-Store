//
//  SummaryViewCell.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 26.02.2023.
//

import UIKit
import Stevia

protocol OrderSummaryViewModel {
    var subtotal: String { get }
    var shipping: String { get }
    var total: String { get }
}

class SummaryViewCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Oswald.medium.withSize(18)
        label.text = "ORDER SUMMARY"
        return label
    }()
    
    private let subtotalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.regular
        label.text = "Subtotal"
        return label
    }()
    
    private let shippingCostLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.regular
        label.text = "Shipping cost"
        return label
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.bold
        label.text = "TOTAL"
        return label
    }()
    
    private let subtotalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.regular
        label.text = "$ 129.00"
        return label
    }()
    
    private let shippingPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.regular
        label.text = "$ 12.00"
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.bold
        label.text = "$ 141.00"
        return label
    }()
    
    private let applePayButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appBlack
        button.tintColor = .appWhite
        let image = UIImage(systemName: "applelogo")!
        button.setImage(image, for: .normal)
        button.setTitle(" Pay", for: .normal)
        return button
    }()
    
    var viewModel: OrderSummaryViewModel? {
        didSet {
            guard let viewModel else { return }
            subtotalPriceLabel.text = viewModel.subtotal
            shippingPriceLabel.text = viewModel.shipping
            totalPriceLabel.text = viewModel.total
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        addBorder(at: .top, color: .appGray, width: 0.5)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func configureLayout() {
        
        let subtotalStack = createStack(label1: subtotalLabel, label2: subtotalPriceLabel)
        let shippingStack = createStack(label1: shippingCostLabel, label2: shippingPriceLabel)
        let totalStack = createStack(label1: totalLabel, label2: totalPriceLabel)
        
        subviews(
            titleLabel,
            subtotalStack,
            shippingStack,
            totalStack,
            applePayButton
        )
        
        let padding = 0.05 * frame.width
        titleLabel.fillHorizontally(padding: padding).top(padding)
        subtotalStack.left(2 * padding).right(padding).Top == titleLabel.Bottom + padding
        shippingStack.left(2 * padding).right(padding).Top == subtotalStack.Bottom + padding
        totalStack.left(2 * padding).right(padding).Top == shippingStack.Bottom + padding
        applePayButton.fillHorizontally(padding: padding).height(44).bottom(0).Top == totalStack.Bottom + padding
        
        func createStack(label1: UILabel, label2: UILabel) -> UIStackView {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.alignment = .fill
            stack.distribution = .equalSpacing
            stack.spacing = 8
            label1.setContentCompressionResistancePriority(.init(100), for: .horizontal)
            stack.addArrangedSubview(label1)
            stack.addArrangedSubview(label2)
            return stack
        }
    }
}
