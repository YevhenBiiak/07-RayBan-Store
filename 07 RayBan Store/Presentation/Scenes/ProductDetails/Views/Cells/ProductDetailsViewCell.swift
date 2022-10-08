//
//  ProductDetailsViewCell.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 19.09.2022.
//

import UIKit
import Stevia

class ProductDetailsViewCell: UICollectionViewCell {
    
    private let productDetailsTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.Oswald.regular
        label.textColor = UIColor.appBlack
        label.text = "PRODUCT DETAILS"
        return label
    }()
     
    private let productDetailsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.Lato.regular
        label.textColor = UIColor.appDarkGray
        return label
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
        addBorder(atPosition: .top, color: UIColor.appDarkGray, width: 0.5)
    }
    
    func setDetails(text: String?) {
        productDetailsLabel.text = text
    }
    
    private func configureLayout() {
        subviews(
            productDetailsTitleLabel,
            productDetailsLabel
        )
        productDetailsTitleLabel.width(90%).top(16).centerHorizontally()
        productDetailsLabel.width(90%).centerHorizontally().bottom(16).Top == productDetailsTitleLabel.Bottom + 16
    }
}
