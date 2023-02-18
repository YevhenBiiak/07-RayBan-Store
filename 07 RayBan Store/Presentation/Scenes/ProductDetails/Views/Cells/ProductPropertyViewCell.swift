//
//  ProductPropertyViewCell.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 19.09.2022.
//

//import UIKit
//import Stevia
//
//class ProductPropertyViewCell: UICollectionViewCell {
//    
//    let propertyLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.Oswald.regular
//        label.textColor = UIColor.appBlack
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .appWhite
//        configureLayout()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func draw(_ rect: CGRect) {
//        addBorder(at: .top, color: UIColor.appDarkGray, width: 0.5)
//    }
//    
//    func configure(title: String, value: String?) {
//        let text = NSMutableAttributedString(string: "\(title.uppercased())")
//        let attrs: [NSAttributedString.Key: Any] = [
//            .foregroundColor: UIColor.appDarkGray
//        ]
//        
//        let attrString = NSAttributedString(
//            string: "  \(value?.uppercased() ?? "")",
//            attributes: attrs)
//        
//        text.append(attrString)
//        
//        propertyLabel.attributedText = text
//    }
//    
//    private func configureLayout() {
//        subviews(propertyLabel)
//        propertyLabel.width(90%).centerHorizontally().height(100%)
//    }
//}
