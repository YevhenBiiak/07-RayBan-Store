//
//  CategoryViewCell.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 30.09.2022.
//

//import UIKit
//import Stevia
//
//class CategoryViewCell: UICollectionViewCell {
//    
//    private let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.isHidden = true
//        return imageView
//    }()
//    
//    private let label: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.Oswald.medium
//        label.textColor = UIColor.appBlack
//        label.textAlignment = .center
//        return label
//    }()
//    
//    private lazy var stackView = {
//        let stack = UIStackView(arrangedSubviews: [imageView, label])
//        stack.axis = .vertical
//        stack.alignment = .center
//        stack.spacing = -40
//        return stack
//    }()
//    
//    private var imageShimmerView = ShimmerView()
//    private var titleShimmerView = ShimmerView()
//    
//    // MARK: - Initializers and overridden methods
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureLayout()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func draw(_ rect: CGRect) {
//        addBorders(color: UIColor.appGray, width: 0.5)
//    }
//    
//    // MARK: - Update methods
//    
//    func configure(with model: CategoryVM) {
//        stopAnimating()
//        if let image = model.image {
//            imageView.isHidden = false
//            imageView.image = image
//            label.font = label.font.withSize(16)
//        } else {
//            imageView.isHidden = true
//            label.font = label.font.withSize(18)
//        }
//        label.text = model.name.uppercased()
//    }
//    
//    // MARK: - Private methods
//    
//    func startLoadingAnimation() {
//        imageShimmerView.startShimmerAnimating()
//        titleShimmerView.startShimmerAnimating()
//    }
//    
//    private func stopAnimating() {
//        imageShimmerView.stopShimmerAnimating()
//        titleShimmerView.stopShimmerAnimating()
//    }
//    
//    private func configureLayout() {
//        subviews(stackView)
//        
//        label.height(80)
//        imageView.width(85%)
//        stackView.fillContainer()
//        
//        // configure shummer views
//        subviews(imageShimmerView)
//        subviews(titleShimmerView)
//        
//        imageShimmerView.fillHorizontally().top(0)
//        titleShimmerView.height(35).width(80%).centerHorizontally().bottom(16).Top == imageShimmerView.Bottom + 16
//    }
//}
