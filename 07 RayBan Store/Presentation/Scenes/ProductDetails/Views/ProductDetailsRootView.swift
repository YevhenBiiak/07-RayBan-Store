//
//  ProductDetailsRootView.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 18.09.2022.
//

import UIKit
import Stevia

protocol ColorSegmentedControlDelegate: AnyObject {
    func didSelectSegment(atIndex index: Int)
}

class ProductDetailsRootView: UIView {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var collectionView: UICollectionView!
    
    let nameLabel: UILabel = {
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
        let button = CheckboxButton(checkedImage: checkedImage, uncheckedImage: uncheckedImage, scale: .large)
        return button
    }()
    
    private let colorsCountTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.regular
        label.textColor = .appBlack
        label.text = "COLORS"
        return label
    }()
    
    private let colorsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.regular
        label.textColor = .appDarkGray
        return label
    }()
    
    private let colorSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        return segmentedControl
    }()
    
    private let sizeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.regular
        label.textColor = .appBlack
        label.text = "SIZE"
        return label
    }()
    
    let sizeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.regular
        label.textColor = .appDarkGray
        return label
    }()
    
    private let geofitTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.regular
        label.textColor = .appBlack
        label.text = "GEOFIT"
        return label
    }()
    
    let geofitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.regular
        label.textColor = .appDarkGray
        return label
    }()
    
    private let productDetailsTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.Oswald.regular
        label.textColor = .appBlack
        label.text = "PRODUCT DETAILS"
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.font = UIFont.Lato.regular
        label.textColor = .appDarkGray
        return label
    }()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.regular.withSize(20)
        label.textColor = .appBlack
        label.text = "PRICE"
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.Oswald.regular.withSize(20)
        label.textColor = .appRed
        return label
    }()
    
    let applePayButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appBlack
        button.tintColor = .appWhite
        let image = UIImage(systemName: "applelogo")!
        button.setImage(image, for: .normal)
        button.setTitle(" Pay", for: .normal)
        return button
    }()
    
    let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.Oswald.bold
        button.tintColor = .appWhite
        return button
    }()
    
    private let trailingBuyButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.Oswald.bold
        button.tintColor = .appWhite
        return button
    }()
    
    weak var colorSegmentsDelegate: ColorSegmentedControlDelegate?
    
    var showActivityIndicator: Bool = false {
        didSet { collectionView.reloadData() }
    }
    
    var isProductInFavorite: Bool = false {
        didSet { favoriteButton.isChecked = isProductInFavorite }
    }
    
    var imageData: [Data] = [] {
        didSet { collectionView.reloadData() }
    }
    
    var selectedColorSegment: Int = 0 {
        didSet { colorSegmentedControl.selectedSegmentIndex = selectedColorSegment }
    }
    
    var colorSegments: [String] = [] {
        didSet {
            colorsCountLabel.text = "\(colorSegments.count)"
            colorSegmentedControl.removeAllSegments()
            for (i, title) in colorSegments.enumerated() {
                colorSegmentedControl.insertSegment(withTitle: title, at: i, animated: false)
            }
        }
    }
    
    var addToCartButtonTitle: String = "ADD TO BAG" {
        didSet {
            addToCartButton.setTitle(addToCartButtonTitle, for: .normal)
            trailingBuyButton.setTitle(addToCartButtonTitle, for: .normal)
        }
    }
    var addToCartButtonCoolor: UIColor = .appRed {
        didSet {
            addToCartButton.backgroundColor = addToCartButtonCoolor
            trailingBuyButton.backgroundColor = addToCartButtonCoolor
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func draw(_ rect: CGRect) {
        configureLayout()
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        backgroundColor = .appWhite
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: creatrLayout())
        collectionView.register(ProductImageViewCell.self,
                                forCellWithReuseIdentifier: ProductImageViewCell.reuseId)
        collectionView.backgroundColor = .appLightGray
        collectionView.dataSource = self
        scrollView.delegate = self
        
        colorSegmentedControl.addTarget(self, action: #selector(didSelectSegment), for: .valueChanged)
        trailingBuyButton.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
    }
    
    @objc private func didSelectSegment() {
        colorSegmentsDelegate?.didSelectSegment(atIndex: colorSegmentedControl.selectedSegmentIndex)
    }
    
    @objc private func addToCartButtonTapped() {
        addToCartButton.sendActions(for: .touchUpInside)
    }
    
    private func creatrLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout(sectionProvider: { _, _ in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .fractionalHeight(1)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            
            return section
        })
    }
    
    private func configureLayout() {
        
        let descriptionSection = UIView()
        let sizeSection = UIView()
        let geofitSection = UIView()
        let detailsSection = UIView()
        let priceSection = UIView()
        
        descriptionSection.addBorder(at: .top, color: .appLightGray, width: 1)
        sizeSection.addBorder(at: .top, color: .appLightGray, width: 1)
        geofitSection.addBorder(at: .top, color: .appLightGray, width: 1)
        detailsSection.addBorder(at: .top, color: .appLightGray, width: 1)
        priceSection.addBorder(at: .top, color: .appLightGray, width: 1)
        
        subviews(
            scrollView.subviews(
                contentView.subviews(
                    collectionView,
                    descriptionSection.subviews(nameLabel, favoriteButton, colorsCountTitleLabel, colorsCountLabel, colorSegmentedControl),
                    sizeSection.subviews(sizeTitleLabel, sizeLabel),
                    geofitSection.subviews(geofitTitleLabel, geofitLabel),
                    detailsSection.subviews(productDetailsTitleLabel, descriptionLabel),
                    priceSection.subviews(priceTitleLabel, priceLabel, applePayButton, addToCartButton)
                )
            ),
            trailingBuyButton
        )
        
        // set constraints
        scrollView.fillHorizontally().fillVertically()
        contentView.fillHorizontally().fillVertically().width(100%)
        trailingBuyButton.width(90%).centerHorizontally().height(44).Bottom == safeAreaLayoutGuide.Bottom
        
        collectionView    .fillHorizontally().height(300).top(0)
        descriptionSection.fillHorizontally().Top == collectionView.Bottom
        sizeSection       .fillHorizontally().Top == descriptionSection.Bottom
        geofitSection     .fillHorizontally().Top == sizeSection.Bottom
        detailsSection    .fillHorizontally().Top == geofitSection.Bottom
        priceSection      .fillHorizontally().bottom(0).Top == detailsSection.Bottom
        
        // layout DescriptionSection
        let padding = 0.05 * frame.width
        nameLabel.top(16).left(padding).Right == favoriteButton.Left - 8
        favoriteButton.width(36).height(36).right(padding).Top == nameLabel.Top
        colorsCountTitleLabel.Top == nameLabel.Bottom + 14
        colorsCountTitleLabel.left(padding).Right == colorsCountLabel.Left - 8
        colorsCountLabel.right(padding).CenterY == colorsCountTitleLabel.CenterY
        colorsCountLabel.setContentHuggingPriority(.init(100), for: .horizontal)
        colorSegmentedControl.fillHorizontally(padding: padding).bottom(20).Top == colorsCountTitleLabel.Bottom + 16
        
        // layout SizeSection
        sizeTitleLabel.left(padding).height(60).top(0).bottom(0)
        sizeLabel.right(padding).height(60).top(0).bottom(0).Left == sizeTitleLabel.Right + 8
        sizeLabel.setContentHuggingPriority(.init(100), for: .horizontal)
        
        // layout GeofitSection
        geofitTitleLabel.left(padding).height(60).top(0).bottom(0)
        geofitLabel.right(padding).height(60).top(0).bottom(0).Left == geofitTitleLabel.Right + 8
        geofitLabel.setContentHuggingPriority(.init(100), for: .horizontal)
        
        // layout DetailsSection
        productDetailsTitleLabel.fillHorizontally(padding: padding).top(16)
        descriptionLabel.fillHorizontally(padding: padding).bottom(16).Top == productDetailsTitleLabel.Bottom + 16
        
        // layout PriceSection
        priceTitleLabel.left(padding).top(padding)
        priceLabel.right(padding).top(padding).Left == priceTitleLabel.Right + 8
        priceLabel.setContentHuggingPriority(.init(100), for: .horizontal)
        applePayButton.fillHorizontally(padding: padding).height(44).Top == priceTitleLabel.Bottom + padding
        addToCartButton.fillHorizontally(padding: padding).height(44).bottom(0).Top == applePayButton.Bottom + padding
    }
}

extension ProductDetailsRootView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        max(imageData.count, 1) // display image.count cells or one for activity Indicator
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageViewCell.reuseId, for: indexPath)
        guard let cell = cell as? ProductImageViewCell else { return cell }
        
        if imageData.count > indexPath.item {
            let data = imageData[indexPath.item]
            cell.imageView.image = UIImage(data: data)
        }
        
        showActivityIndicator
            ? cell.activityIndicator.startAnimating()
            : cell.activityIndicator.stopAnimating()
        
        return cell
    }
}

extension ProductDetailsRootView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let addToCartButtonIsVisible = scrollView.bounds.intersects(priceLabel.frame)
        
        if addToCartButtonIsVisible, trailingBuyButton.isHidden == true {
            trailingBuyButton.isHidden = false
//            trailingBuyButton.setTitle("SHOP - \(priceLabel.text ?? "")", for: .normal)
        }
        if !addToCartButtonIsVisible, trailingBuyButton.isHidden == false {
            trailingBuyButton.isHidden = true
        }
    }
}
