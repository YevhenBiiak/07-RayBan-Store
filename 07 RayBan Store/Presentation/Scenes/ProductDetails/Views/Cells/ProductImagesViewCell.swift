//
//  ProductImagesViewCell.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 19.09.2022.
//

//import UIKit
//import Stevia
//
//protocol ProductImagesViewCellDelegate: AnyObject {
//    func imageViewCellDidZoom(cell: ProductImagesViewCell)
//    func imageViewCellEndZoom(cell: ProductImagesViewCell)
//}
//
//class ProductImagesViewCell: UICollectionViewCell {
//    
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.backgroundColor = UIColor.appLightGray
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()
//    
//    private var zoomableView = ZoomableView()
//    weak var delegate: ProductImagesViewCellDelegate?
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureLayout()
//        
//        zoomableView.sourceView = imageView
//        zoomableView.delegate = self
//        zoomableView.isZoomable = true
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setImage(image: UIImage?) {
//        imageView.image = image
//    }
//    
//    private func configureLayout() {
//        subviews( zoomableView )
//        zoomableView.fillContainer()    
//    }
//}
//
//extension ProductImagesViewCell: ZoomableViewDelegate {
//    func zoomableViewShouldZoom(_ view: ZoomableView) -> Bool {
//        return true
//    }
//    
//    func zoomableViewDidZoom(_ view: ZoomableView) {
//        delegate?.imageViewCellDidZoom(cell: self)
//    }
//    
//    func zoomableViewEndZoom(_ view: ZoomableView) {
//        delegate?.imageViewCellEndZoom(cell: self)
//    }
//}
