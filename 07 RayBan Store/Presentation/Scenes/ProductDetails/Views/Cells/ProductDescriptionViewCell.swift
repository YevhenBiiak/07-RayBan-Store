//
//  ProductDescriptionViewCell.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 19.09.2022.
//

import UIKit
import Stevia

protocol ColorSegmentsDelegate: AnyObject {
    func didSelectSegment(atIndex index: Int)
}

class ProductDescriptionViewCell: UICollectionViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
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

    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        return segmentedControl
    }()
    
    weak var delegate: ColorSegmentsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appWhite
        configureLayout()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        addBorder(atPosition: .top, color: UIColor.appDarkGray, width: 0.5)
    }
    
    // MARK: - Update methods
    
    func setNameLabel(_ text: String?) {
        nameLabel.text = text
    }
    
    func setColors(number: Int?) {
        let text = NSMutableAttributedString(string: "COLORS")
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.appDarkGray
        ]
        let attrString = NSAttributedString(string: "  \(number ?? 0)", attributes: attrs)
        text.append(attrString)
        colorsLabel.attributedText = text
    }

    func insertColorSegment(at index: Int, title: String, animated: Bool) {
        segmentedControl.insertSegment(withTitle: title.uppercased(), at: index, animated: animated)
    }

    func setSelectedSegmentIndex(_ index: Int) {
        segmentedControl.selectedSegmentIndex = index
    }
    
    func removeAllColorSegments() {
        segmentedControl.removeAllSegments()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        segmentedControl.addTarget(self, action: #selector(didSelectSegment), for: .valueChanged)
    }
    
    @objc private func didSelectSegment() {
        delegate?.didSelectSegment(atIndex: segmentedControl.selectedSegmentIndex)
    }
    
    private func configureLayout() {
        subviews(
            nameLabel,
            favoriteButton,
            colorsLabel,
            segmentedControl
        )
            
        let padding = 0.05 * frame.width
        nameLabel.top(16).left(padding).Right == favoriteButton.Left - padding
        favoriteButton.right(padding).CenterY == nameLabel.CenterY
        colorsLabel.left(padding).right(padding).centerHorizontally().Top == nameLabel.Bottom + 14
        segmentedControl.centerHorizontally().width(90%).bottom(20).Top == colorsLabel.Bottom + 16
    }
}
