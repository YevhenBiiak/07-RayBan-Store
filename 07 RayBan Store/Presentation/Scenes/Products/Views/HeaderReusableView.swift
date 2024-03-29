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
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.regular.withSize(18)
        label.textColor = UIColor.appBlack
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        subviews( headerLabel )
        let padding = 0.025 * frame.width
        headerLabel.fillHorizontally(padding: padding).fillVertically()
    }
}
