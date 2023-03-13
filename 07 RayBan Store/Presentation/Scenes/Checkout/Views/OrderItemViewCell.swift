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
    var color: String { get }
    var price: String { get }
    var quantity: String { get }
    var imageData: Data { get }
}

class OrderItemViewCell: UICollectionViewCell {
    
    private let orderItemView = OrderItemView()
    
    var viewModel: OrderItemViewModel? {
        didSet {
            guard let viewModel else { return }
            orderItemView.setImage(with: viewModel.imageData)
            orderItemView.nameLabel.text = viewModel.name
            orderItemView.colorLabel.text = viewModel.color
            orderItemView.priceLabel.text = viewModel.price
            orderItemView.quantityLabel.text = viewModel.quantity
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        addBorder(at: .top, color: .appGray, width: 0.5)
        addBorder(at: .bottom, color: .appGray, width: 0.5)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func configureLayout() {
        subviews(orderItemView)
        orderItemView.fillContainer()
    }
}
