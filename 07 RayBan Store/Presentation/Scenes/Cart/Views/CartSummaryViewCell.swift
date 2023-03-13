//
//  CartSummaryViewCell.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 26.02.2023.
//

import UIKit
import Stevia

protocol CartSummaryViewModel {
    var subtotal: String { get }
    var discount: String { get }
    var total: String { get }
    var checkoutButtonTapped: () async -> Void { get }
}

class CartSummaryViewCell: UICollectionViewCell {
    
    private let subtotalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appDarkGray
        label.font = .Lato.regular
        label.text = "Subtotal"
        return label
    }()
    
    private let shippingCostLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appDarkGray
        label.font = .Lato.regular
        label.text = "Discount"
        return label
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.bold.withSize(18)
        label.text = "TOTAL"
        return label
    }()
    
    private let subtotalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appDarkGray
        label.font = .Lato.regular
        label.text = "$ 129.00"
        return label
    }()
    
    private let shippingPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appDarkGray
        label.font = .Lato.regular
        label.text = "$ 12.00"
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.bold.withSize(18)
        label.text = "$ 141.00"
        return label
    }()
    
    private let checkoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.Oswald.bold
        button.backgroundColor = .appRed
        button.tintColor = .appWhite
        button.setTitle("CHECKOUT NOW", for: .normal)
        return button
    }()
    
    var viewModel: CartSummaryViewModel? {
        didSet {
            guard let viewModel else { return }
            subtotalPriceLabel.text = viewModel.subtotal
            shippingPriceLabel.text = viewModel.discount
            totalPriceLabel.text = viewModel.total
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        addBorder(at: .top, color: .appGray, width: 0.5)
        
        checkoutButton.addAction { [weak self] in
            Task { await self?.viewModel?.checkoutButtonTapped() }
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func configureLayout() {
        
        let subtotalStack = createStack(label1: subtotalLabel, label2: subtotalPriceLabel)
        let shippingStack = createStack(label1: shippingCostLabel, label2: shippingPriceLabel)
        let totalStack = createStack(label1: totalLabel, label2: totalPriceLabel)
        
        subviews(
            subtotalStack,
            shippingStack,
            totalStack,
            checkoutButton
        )
        
        let padding = 0.05 * frame.width
        subtotalStack.left(padding).top(padding).right(padding)
        shippingStack.left(padding).right(padding).Top == subtotalStack.Bottom + padding
        totalStack.left(padding).right(padding).Top == shippingStack.Bottom + padding
        checkoutButton.fillHorizontally(padding: padding).height(44).bottom(0).Top == totalStack.Bottom + padding
        
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
