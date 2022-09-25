//
//  ProductViewCell.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import UIKit
import Stevia

class ProductsCollectionViewCell: UICollectionViewCell {
    
    let productImageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = UIColor.appGray
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let newLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.regular
        label.textColor = .red
        return label
    }()
    
    let colorsLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.appBlack
        label.font = UIFont.Oswald.regular.withSize(14)
        label.text = "11 COLORS"
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.medium
        label.textColor = UIColor.appBlack
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.appBlack
        button.titleLabel?.font = UIFont.Oswald.bold
        button.setTitleColor(.white, for: .normal)
        button.setTitle("ADD TO BAG", for: .normal)
        return button
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Lato.bold
        label.textColor = UIColor.appBlack
        return label
    }()
    
    // MARK: - Initializers and overridden methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration methods
    
    func setIsNew(flag: Bool) {
        newLabel.text = flag ? "NEW" : ""
    }
    
    func setImage(_ data: Data?) {
        productImageView.image = UIImage(data: data ?? Data())
    }
    
    func setColors(number: Int) {
        colorsLabel.text = "\(number) COLORS".uppercased()
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title.uppercased()
    }
    
    func setPrice(_ price: Int) {
        priceLabel.text = "price: $ " + String(format: "%.2f", Double(price))
    }
    
    // MARK: - Private methods
    
    private func addSubview() {
        subviews(
            productImageView.subviews(
                newLabel,
                colorsLabel
            ),
            titleLabel,
            buyButton,
            priceLabel
        )
        
        let padding = 0.05 * frame.width
        
        productImageView.width(100%).top(0).heightEqualsWidth()
        newLabel.right(padding).top(padding)
        colorsLabel.left(padding).bottom(padding)
        titleLabel.width(90%).centerHorizontally().Top == productImageView.Bottom + padding
        priceLabel.width(90%).centerHorizontally().Top == titleLabel.Bottom + padding
        buyButton.width(100%).height(40).bottom(padding).Top == priceLabel.Bottom + padding
    }
}
