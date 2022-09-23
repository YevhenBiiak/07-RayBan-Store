//
//  ProductPropertyViewCell.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 19.09.2022.
//

import UIKit
import Stevia

class ProductPropertyCollectionViewCell: UICollectionViewCell {
    
    let propertyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.regular
        label.textColor = UIColor.appBlack
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        addBorder(atPosition: .top, color: UIColor.appDarkGray, width: 0.5)
    }
    
    func setText(_ title: String, value: String) {
        let text = NSMutableAttributedString(string: "\(title.uppercased())")
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appDarkGray
        ]
        let attrString = NSAttributedString(string: "  \(value.uppercased())", attributes: attrs)
        text.append(attrString)
        propertyLabel.attributedText = text
    }
    
    private func setupView() {
        subviews(propertyLabel)
        propertyLabel.width(90%).centerHorizontally().height(100%)
    }
}
