//
//  ProductImageViewCell.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 19.09.2022.
//

import UIKit
import Stevia

class ProductImageViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .appLightGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let activityIndicator = ActivityIndicatorView()
    
    private var zoomableView = ZoomableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        
        zoomableView.sourceView = imageView
        zoomableView.delegate = self
        zoomableView.isZoomable = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        subviews(
            zoomableView,
            activityIndicator
        )
        zoomableView.fillContainer()
        activityIndicator.centerInContainer()
    }
}

extension ProductImageViewCell: ZoomableViewDelegate {
    
    func zoomableViewDidZoom(_ view: ZoomableView) { }
    
    func zoomableViewEndZoom(_ view: ZoomableView) { }
    
    func zoomableViewShouldZoom(_ view: ZoomableView) -> Bool {
        return true
    }
}
