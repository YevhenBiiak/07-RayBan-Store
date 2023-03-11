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
    
    private let itemView = OrderItemView()
    
    var viewModel: OrderItemViewModel? {
        didSet {
            guard let viewModel else { return }
            setImage(with: viewModel.imageData)
            itemView.nameLabel.text = viewModel.name
            itemView.colorLabel.text = viewModel.color
            itemView.priceLabel.text = viewModel.price
            itemView.quantityLabel.text = viewModel.quantity
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
                self.itemView.imageView.image = image
            }
        }
    }
    
    private func configureLayout() {
        subviews(itemView)
        itemView.fillContainer()
    }
}
