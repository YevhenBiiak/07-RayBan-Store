//
//  HeaderReusableView.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 26.09.2022.
//

import UIKit
import Stevia

class HeaderReusableView: UICollectionReusableView {
    static let elementKind = "header"
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.regular.withSize(18)
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
    
    func setProducts(count: Int) {
        headerLabel.text = "\(String(count)) PRODUCTS"
    }
    
    private func setupView() {
        subviews( headerLabel )
        let padding = 0.025 * frame.width
        headerLabel.fillHorizontally(padding: padding).fillVertically()
    }
}
