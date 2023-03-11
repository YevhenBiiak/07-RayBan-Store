//
//  OrderItemView.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 11.03.2023.
//

import UIKit
import Stevia

class OrderItemView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .appLightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Oswald.regular
        label.numberOfLines = 1
        label.text = "NAME NAME NAME NAME"
        return label
    }()
    
    let colorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appDarkGray
        label.font = .Lato.regular.withSize(14)
        label.text = "color: black/green"
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appBlack
        label.font = .Oswald.regular
        label.textAlignment = .right
        label.text = "$ 129.00"
        return label
    }()
    
    let quantityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appDarkGray
        label.font = .Lato.medium
        label.textAlignment = .right
        label.text = "qty: 2"
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Private methods
        
    private func configureLayout() {
        
        subviews(
            imageView,
            nameLabel,
            colorLabel,
            priceLabel,
            quantityLabel
        )
        
        imageView.left(0).top(0).bottom(0).heightEqualsWidth()
        nameLabel.top(8).right(16).Left == imageView.Right + 10
        colorLabel.Top == nameLabel.Bottom + 6
        colorLabel.right(16).Left == imageView.Right + 10
        priceLabel.Top == colorLabel.Bottom + 6
        priceLabel.bottom(12).Left == imageView.Right + 10
        quantityLabel.right(16).CenterY == priceLabel.CenterY
        
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
        colorLabel.setContentHuggingPriority(.required, for: .vertical)
        priceLabel.setContentHuggingPriority(.required, for: .vertical)
    }
}
