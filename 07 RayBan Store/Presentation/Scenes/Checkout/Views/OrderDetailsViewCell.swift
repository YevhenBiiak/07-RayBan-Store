//
//  OrderDetailsViewCell.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.03.2023.
//

import UIKit
import Stevia

protocol ShippingMethodViewModel {
    var name: String { get }
    var duration: String { get }
    var price: String { get }
    var isSelected: Bool { get }
    var didSelectMethod: () async -> Void { get }
}

protocol OrderDetailsViewModel {
    var shippingMethods: [ShippingMethodViewModel] { get }
    var subtotal: String { get }
    var shippingCost: String { get }
    var total: String { get }
}

class OrderDetailsViewCell: UICollectionViewCell {
    
    private let shippingContainer: OrderDetailsContainer = {
        let container = OrderDetailsContainer()
        container.titleLabel.text = "SELECT A SHIPPING METHOD"
        return container
    }()
    
    private let summaryContainer: OrderDetailsContainer = {
        let container = OrderDetailsContainer()
        container.titleLabel.text = "ORDER SUMMARY"
        return container
    }()
    
    private let shippingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    private let summaryView = SummaryView()
    
    var viewModel: OrderDetailsViewModel? {
        didSet {
            guard let viewModel else { return }
            
            shippingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for shipping in viewModel.shippingMethods {
                let shippingItem = ShippingItemView()
                shippingItem.titleLabel.text = shipping.name
                shippingItem.subtitleLabel.text = shipping.duration
                shippingItem.priceLabel.text = shipping.price
                shippingItem.checkboxButton.isChecked = shipping.isSelected
                shippingItem.checkboxButton.addTarget(self, action: #selector(shippingMethodSelected), for: .touchUpInside)
                shippingStackView.addArrangedSubview(shippingItem)
            }
            
            summaryView.subtotalPriceLabel.text = viewModel.subtotal
            summaryView.shippingPriceLabel.text = viewModel.shippingCost
            summaryView.totalPriceLabel.text = viewModel.total
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
    
    @objc private func shippingMethodSelected(_ sender: CheckboxButton) {
        for (i, item) in shippingStackView.arrangedSubviews.enumerated() {
            guard let shippingView = item as? ShippingItemView else { break }
            
            if shippingView.checkboxButton == sender {
                Task {
                    let shippingMethod = viewModel?.shippingMethods[i]
                    await shippingMethod?.didSelectMethod()
                }
                shippingView.checkboxButton.isChecked = true
            } else {
                shippingView.checkboxButton.isChecked = false
            }
        }
    }
    
    private func configureLayout() {
        
        shippingContainer.contentView.subviews(shippingStackView)
        summaryContainer.contentView.subviews(summaryView)
        
        subviews(
            shippingContainer,
            summaryContainer
        )
        
        let padding = 0.05 * frame.width
        shippingStackView.fillContainer()
        summaryView.fillContainer()
        shippingContainer.left(padding).top(padding).right(padding)
        summaryContainer.left(padding).bottom(padding).right(padding).Top == shippingContainer.Bottom + padding
    }
}

private class ShippingItemView: UIView {
    
    let checkboxButton: CheckboxButton = {
        let config = UIImage.SymbolConfiguration(paletteColors: [.appBlack])
        let checkedImage = UIImage(systemName: "checkmark.circle.fill", withConfiguration: config)!
        let uncheckedImage = UIImage(systemName: "circle", withConfiguration: config)!
        return CheckboxButton(checkedImage: checkedImage, uncheckedImage: uncheckedImage, scale: .medium)
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.regular
        label.text = "Standart Shipping"
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .appDarkGray
        label.font = .Lato.regular.withSize(14)
        label.text = "(4-5 business days)"
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.regular
        label.text = "FREE"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Private methods
    
    private func setupViews() {
        backgroundColor = .appWhite
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectAction))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func selectAction() {
        checkboxButton.sendActions(for: .touchUpInside)
    }
    
    private func configureLayout() {
        subviews(
            checkboxButton,
            titleLabel,
            subtitleLabel,
            priceLabel
        )
        
        checkboxButton.width(42).left(0).heightEqualsWidth().CenterY == CenterY
        priceLabel.top(8).right(8).bottom(8)
        titleLabel.top(8).Left == checkboxButton.Right
        titleLabel.Right == priceLabel.Left - 8
        subtitleLabel.bottom(8).Left == checkboxButton.Right
        subtitleLabel.Right == priceLabel.Left - 8
        subtitleLabel.Top == titleLabel.Bottom
        
        priceLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        subtitleLabel.setContentCompressionResistancePriority(.init(749), for: .horizontal)
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
