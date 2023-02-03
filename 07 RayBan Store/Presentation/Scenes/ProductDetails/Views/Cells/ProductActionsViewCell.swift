//
//  ProductActionsViewCell.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 19.09.2022.
//

import UIKit
import Stevia

class ProductActionsViewCell: UICollectionViewCell {
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.regular.withSize(20)
        label.textColor = UIColor.appBlack
        return label
    }()
    
    let applePayButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.appBlack
        button.tintColor = UIColor.appWhite
        let image = UIImage(systemName: "applelogo")!
        button.setImage(image, for: .normal)
        button.setTitle(" Pay", for: .normal)
        return button
    }()
    
    let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.Oswald.bold
        button.backgroundColor = UIColor.appRed
        button.tintColor = UIColor.appWhite
        button.setTitle("ADD TO BAG", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appWhite
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        addBorder(at: .top, color: .appDarkGray, width: 0.5)
    }
    
    func setPrice(_ price: Int, withColor color: UIColor) {
        let text = NSMutableAttributedString(string: "PRICE")
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: color
        ]
        let formattedPrice = String(format: "%.2f", Double(price) / 100.0)
        let attrString = NSAttributedString(string: "  $ \(formattedPrice)", attributes: attrs)
        text.append(attrString)
        priceLabel.attributedText = text
    }
    
    private func configureLayout() {
        subviews(
            priceLabel,
            applePayButton,
            addToCartButton
        )
        
        let padding = 0.05 * frame.width
        priceLabel.width(90%).centerHorizontally().top(padding)
        applePayButton.width(90%).height(44).centerHorizontally().Top == priceLabel.Bottom + padding
        addToCartButton.width(90%).height(44).centerHorizontally().bottom(0).Top == applePayButton.Bottom + padding
    }
}
