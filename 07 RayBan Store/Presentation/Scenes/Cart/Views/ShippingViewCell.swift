//
//  ShippingViewCell.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 26.02.2023.
//

import UIKit
import Stevia

protocol ShippingMethodModel {
    var isSelected: Bool { get }
    var title: String { get }
    var subtitle: String { get }
    var price: String { get }
}

class ShippingViewCell: UICollectionViewCell {
    
    private let content: UIView = {
        let view = UIView()
        view.backgroundColor = .appGray
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Oswald.medium.withSize(18)
        label.text = "SELECT A SHIPPING METHOD"
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    var shippingMethods: [ShippingMethodModel] = [] {
        didSet {
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for method in shippingMethods {
                let shippingItem = ShippingItemView()
                shippingItem.checkboxButton.isChecked = method.isSelected
                shippingItem.titleLabel.text = method.title
                shippingItem.subtitleLabel.text = method.subtitle
                shippingItem.priceLabel.text = method.price
                shippingItem.checkboxButton.addTarget(self, action: #selector(shippingMethodSelected), for: .touchUpInside)
                stackView.addArrangedSubview(shippingItem)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Private methods
    
    @objc private func shippingMethodSelected(_ sender: CheckboxButton) {
        guard sender.isChecked else { return }
        stackView.arrangedSubviews.forEach {
            ($0 as? ShippingItemView)?.checkboxButton.isChecked = false
        }
        sender.isChecked = true
    }
    
    private func configureLayout() {
        subviews(
            content.subviews(
                titleLabel,
                stackView
            )
        )
        
        let padding = 0.05 * frame.width
        content.fillContainer(padding: padding)
        titleLabel.left(8).top(8).right(8)
        stackView.left(8).right(8).bottom(8).Top == titleLabel.Bottom + padding
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
