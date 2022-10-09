//
//  PromoViewCell.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 09.10.2022.
//

import UIKit
import Stevia

class PromoViewCell: UICollectionViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .appWhite
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appBlack
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String?) {
        label.text = text
    }
    
    private func configureLayout() {
        subviews(label)
        label.fillVertically(padding: 12).fillHorizontally()
    }
}
