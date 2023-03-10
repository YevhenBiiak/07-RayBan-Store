//
//  OrderDetailsViewCell.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.03.2023.
//

import UIKit
import Stevia

protocol OrderDetailsViewModel {
    var shippingTitle: String { get }
    var shippingSubtitle: String { get }
    var shippingPrice: String { get }
    var orderSubtotal: String { get }
    var orderShippingCost: String { get }
    var orderTotal: String { get }
}

class OrderDetailsViewCell: UICollectionViewCell {
    
    private let shippingContainer: OrderDetailsContainer = {
        let container = OrderDetailsContainer()
        container.titleLabel.text = "SHIPPING METHOD"
        return container
    }()
    
    private let summaryContainer: OrderDetailsContainer = {
        let container = OrderDetailsContainer()
        container.titleLabel.text = "ORDER SUMMARY"
        return container
    }()
    
    private let shippingView: ShippingItemView = {
        let view = ShippingItemView()
        view.checkboxButton.isChecked = true
        let action = UIAction { _ in view.checkboxButton.isChecked = true }
        view.checkboxButton.addAction(action, for: .touchUpInside)
        return view
    }()
    
    private let summaryView = SummaryView()
    
    var viewModel: OrderDetailsViewModel? {
        didSet {
            guard let viewModel else { return }
            shippingView.titleLabel.text = viewModel.shippingTitle
            shippingView.subtitleLabel.text = viewModel.shippingSubtitle
            shippingView.priceLabel.text = viewModel.shippingPrice
            summaryView.subtotalPriceLabel.text = viewModel.orderSubtotal
            summaryView.shippingPriceLabel.text = viewModel.orderShippingCost
            summaryView.totalPriceLabel.text = viewModel.orderTotal
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        addBorder(at: .top, color: .appGray, width: 0.5)
        addBorder(at: .bottom, color: .appGray, width: 0.5)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Private methods
    
    private func configureLayout() {
        shippingContainer.contentView.subviews(shippingView)
        summaryContainer.contentView.subviews(summaryView)
        
        subviews(
            shippingContainer,
            summaryContainer
        )
        
        let padding = 0.05 * frame.width
        shippingView.fillContainer()
        summaryView.fillContainer()
        shippingContainer.left(padding).top(padding).right(padding)
        summaryContainer.left(padding).bottom(padding).right(padding).Top == shippingContainer.Bottom + padding
    }
}

private class SummaryView: UIView {
    
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
    
    let subtotalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.regular
        label.text = "$ 129.00"
        return label
    }()
    
    let shippingPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.regular
        label.text = "$ 12.00"
        return label
    }()
    
    let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.bold
        label.text = "$ 141.00"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func configureLayout() {
        
        let subtotalStack = createStack(label1: subtotalLabel, label2: subtotalPriceLabel)
        let shippingStack = createStack(label1: shippingCostLabel, label2: shippingPriceLabel)
        let totalStack = createStack(label1: totalLabel, label2: totalPriceLabel)
        
        subviews(
            subtotalStack,
            shippingStack,
            totalStack
        )
        
        subtotalStack.left(0).top(0).right(0)
        shippingStack.left(0).right(0).Top == subtotalStack.Bottom + 8
        totalStack.left(0).bottom(0).right(0).Top == shippingStack.Bottom + 8
        
        func createStack(label1: UILabel, label2: UILabel) -> UIStackView {
            let stack = UIStackView()
            stack.backgroundColor = .appWhite
            stack.axis = .horizontal
            stack.alignment = .fill
            stack.distribution = .equalSpacing
            stack.spacing = 8
            stack.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
            stack.isLayoutMarginsRelativeArrangement = true
            label1.setContentCompressionResistancePriority(.init(100), for: .horizontal)
            stack.addArrangedSubview(label1)
            stack.addArrangedSubview(label2)
            return stack
        }
    }
}

private class OrderDetailsContainer: UIView {
    
    let contentView = UIView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Oswald.medium.withSize(18)
        label.text = "DETAILS CONTAINER"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .appGray
        configureLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Private methods
    
    private func configureLayout() {
        subviews(
            titleLabel,
            contentView
        )
        
        titleLabel.left(8).top(8).right(8)
        contentView.left(8).right(8).bottom(8).Top == titleLabel.Bottom + 16
    }
}
