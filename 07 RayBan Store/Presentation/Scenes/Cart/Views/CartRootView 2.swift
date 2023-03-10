//
//  CartRootView.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 25.02.2023.
//

import UIKit
import Stevia

class CartRootView: UIView {
    
    private enum Section: Int, Hashable, CaseIterable {
        case cartItems
        case shippingMethod
        case orderSummary
    }
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "image_placeholder")
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
        label.text = "There are no products in your shopping bag."
        return label
    }()
    
    var сollectionView: UICollectionView!
    
    private var observation: NSKeyValueObservation?

    // MARK: - Initializers and overridden methods

    init() {
        super.init(frame: .zero)
        setupViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Private methods
    
    private func setupViews() {
        сollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
        observation = сollectionView.observe(\.contentSize, options: .new) { [weak self] (_, change) in
            self?.backgroundView.isHidden = change.newValue?.height != 0
        }
    }
    
    private func configureLayout() {
        
        subviews(
            сollectionView.subviews (
                backgroundView.subviews(
                    imageView,
                    label
                )
            )
        )
        
        сollectionView.fillContainer()
        backgroundView.Left == safeAreaLayoutGuide.Left
        backgroundView.Right == safeAreaLayoutGuide.Right
        backgroundView.Top == safeAreaLayoutGuide.Top

        imageView.width(90%).heightEqualsWidth().centerHorizontally().top(0)
        label.width(90%).centerHorizontally().bottom(0).Top == imageView.Bottom
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: {
            [weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) in
            
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            switch sectionKind {
            case .cartItems:      return self?.itemsSectionLayout()
            case .shippingMethod: return self?.shippingSectionLayout()
            case .orderSummary:   return self?.summarySectionLayout() }
        })
    }
    
    private func itemsSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(130)),
            subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }

    private func shippingSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)),
            subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }

    private func summarySectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)),
            subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
}
