//
//  EmptyStateView.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 13.03.2023.
//

import UIKit
import Stevia

class EmptyStateView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.8
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .appDarkGray.withAlphaComponent(0.4)
        label.font = .Lato.medium.withSize(24)
        return label
    }()
    
    private var observation: NSKeyValueObservation?
    
    var image: UIImage? {
        didSet { imageView.image = image }
    }
    
    var title: String? {
        didSet { label.text = title }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        isHidden = true
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func observeCollectionView(_ collectionView: UICollectionView) {
        observation = collectionView.observe(\.contentSize, options: .new) { [weak self] (_, change) in
            self?.isHidden = change.newValue?.height != 0
        }
    }
    
    private func configureLayout() {
        subviews(
            imageView,
            label
        )
        
        imageView.width(90%).heightEqualsWidth().centerHorizontally().top(0)
        label.width(90%).centerHorizontally().bottom(0).Top == imageView.Bottom
    }
}
