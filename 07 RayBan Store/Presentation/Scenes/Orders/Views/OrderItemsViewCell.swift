//
//  OrderItemsViewCell.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 11.03.2023.
//

import UIKit
import Stevia

protocol OrderViewModel: ViewModel {
    var date: String { get }
    var items: [OrderItemViewModel] { get }
    var total: String { get }
    var deleteOrderButtonTapped: () async -> Void { get }
    var addToCartButtonTapped: () async -> Void { get }
}

class OrderItemsViewCell: UICollectionViewCell, ViewModelRepresentable {
    
    let orderDateLabel: UILabel = {
        let label = UILabel()
        label.font = .Lato.regular.withSize(14)
        label.textColor = .appDarkGray
        label.text = Date.now.formatted(date: .abbreviated, time: .shortened)
        return label
    }()
    
    private let deleteOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .appRed
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        let image = UIImage(systemName: "trash", withConfiguration: config)
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let itemsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 4
        return stack
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Lato.bold
        label.text = "TOTAL: $905.00"
        return label
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.Oswald.bold
        button.backgroundColor = .appBlack
        button.tintColor = .appWhite
        button.setTitle("ADD TO BAG", for: .normal)
        return button
    }()
    
    private var orderViewModel: OrderViewModel? { viewModel as? OrderViewModel }
    
    var viewModel: ViewModel? {
        didSet {
            guard let orderViewModel else { return }
            
            itemsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            orderDateLabel.text = orderViewModel.date
            totalLabel.text = orderViewModel.total
            
            for item in orderViewModel.items {
                let itemView = OrderItemView()
                itemView.setImage(with: item.imageData)
                itemView.nameLabel.text = item.name
                itemView.colorLabel.text = item.color
                itemView.priceLabel.text = item.price
                itemView.quantityLabel.text = item.quantity
                itemsStackView.addArrangedSubview(itemView)
            }
        }
    }
    
    // MARK: - Initializers and overridden methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Private methods
    
    private func setupViews() {
        configureLayout()
        addBorder(at: .top, color: .appGray, width: 0.5)
        addBorder(at: .bottom, color: .appGray, width: 0.5)
        
        deleteOrderButton.addAction { [weak self] in
            UIApplication.shared.window?.rootViewController?.showDialogAlert(
                title: "Confirm",
                message: "Are you sure you want to delete this order from order history?",
                confirmTitle: "DELETE"
            ) { [weak self] in
                Task { await self?.orderViewModel?.deleteOrderButtonTapped() }
            }
        }
        
        addToCartButton.addAction { [weak self] in
            Task { await self?.orderViewModel?.addToCartButtonTapped() }
        }
    }
    
    private func configureLayout() {
        
        subviews(
            orderDateLabel,
            deleteOrderButton,
            itemsStackView,
            totalLabel,
            addToCartButton
        )
        
        let padding = 0.05 * frame.width
        orderDateLabel.left(padding).CenterY == deleteOrderButton.CenterY
        deleteOrderButton.top(padding).right(padding).Left == orderDateLabel.Right + 8
        itemsStackView.left(padding/2).right(0).Top == orderDateLabel.Bottom + 12
        totalLabel.left(padding).Right == addToCartButton.Left - 8
        addToCartButton.width(40%).right(padding).bottom(padding).Top == itemsStackView.Bottom + 8
        addToCartButton.CenterY == totalLabel.CenterY
        
        deleteOrderButton.setContentHuggingPriority(.required, for: .horizontal)
        deleteOrderButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
