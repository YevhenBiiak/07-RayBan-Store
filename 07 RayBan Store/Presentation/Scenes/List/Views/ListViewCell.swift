//
//  ListViewCell.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 26.09.2022.
//

import UIKit
import Stevia

class ListViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let image = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: image)
        imageView.tintColor = UIColor.appDarkGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.medium.withSize(18)
        label.textColor = UIColor.appBlack
        return label
    }()
    
    // MARK: - Initializers and overridden methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        addBorder(atPosition: [.top, .bottom], color: UIColor.appGray, width: 1)
    }
    
    // MARK: - Update methods
    
    func setTitle(title: String?) {
        label.text = title?.uppercased()
    }
    
    // MARK: - Private methods
    
    private func configureLayout() {
        subviews( label, imageView )
        
        let padding = 0.05 * frame.width

        imageView.size(padding).centerVertically()
        align(horizontally: |-padding-label-imageView-padding-|)
    }
}
