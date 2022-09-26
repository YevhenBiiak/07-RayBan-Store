//
//  ProductDescriptionViewCell.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 19.09.2022.
//

import UIKit
import Stevia

class ProductDescriptionViewCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.Oswald.bold.withSize(18)
        return label
    }()
    
    let favoriteButton: CheckboxButton = {
        let checkedImage = UIImage(systemName: "heart.fill")!
            .withConfiguration(UIImage.SymbolConfiguration(paletteColors: [UIColor.appBlack]))
        let uncheckedImage = UIImage(systemName: "heart")!
            .withConfiguration(UIImage.SymbolConfiguration(paletteColors: [UIColor.appBlack]))
        let button = CheckboxButton(checkedImage: checkedImage, uncheckedImage: uncheckedImage, scale: .medium)

        return button
    }()
    
    private let colorsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.regular
        label.textColor = UIColor.appBlack
        return label
    }()
    
    let colorsSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        return segmentedControl
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
    
    func setTitle(title: String?) {
        titleLabel.text = title?.uppercased()
    }
    
    func setColors(number: Int) {
        let text = NSMutableAttributedString(string: "COLORS")
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appDarkGray
        ]
        let attrString = NSAttributedString(string: "  \(number)", attributes: attrs)
        text.append(attrString)
        colorsLabel.attributedText = text
    }
    
    private func setupView() {
        
        subviews(
            titleLabel,
            favoriteButton,
            colorsLabel,
            colorsSegmentedControl
        )
        
        let padding = 0.05 * frame.width
        titleLabel.top(16).left(padding).Right == favoriteButton.Left - padding
        favoriteButton.right(padding).CenterY == titleLabel.CenterY
        colorsLabel.left(padding).right(padding).centerHorizontally().Top == titleLabel.Bottom + 14
        colorsSegmentedControl.centerHorizontally().width(90%).bottom(20).Top == colorsLabel.Bottom + 16
    }
}
