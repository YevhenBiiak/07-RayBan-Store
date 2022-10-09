//
//  ProductDetailsRootView.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 18.09.2022.
//

import UIKit
import Stevia

class ProductDetailsRootView: UIView {
    
    enum Section: Int, Hashable, CaseIterable {
        case promo
        case images
        case description
        case property
        case details
        case actions
    }
    
    let trailingBuyButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.Oswald.regular
        button.tintColor = UIColor.appWhite
        button.backgroundColor = UIColor.appRed
        return button
    }()
    
    var collectionView: UICollectionView!

    // MARK: - Initializers and overridden methods

    init() {
        super.init(frame: .zero)
        configureCollectinView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPriceForTrailingButton(price: Int) {
        let formattedPrice = String(format: "%.2f", Double(price) / 100.0)
        trailingBuyButton.setTitle("SHOP - $ \(formattedPrice)", for: .normal)
    }
    
    func getNumberOfSections() -> Int {
        Section.allCases.count
    }
    
    func getSectionKind(forSection section: Int) -> ProductDetailsRootView.Section? {
        Section(rawValue: section)
    }
    
    // MARK: - Private methods
    
    private func configureCollectinView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: creatrLayout())
        collectionView.backgroundColor = .appLightGray
        
        subviews(
            collectionView,
            trailingBuyButton
        )
        
        collectionView.width(100%).height(100%).top(0)
        trailingBuyButton.centerHorizontally().width(90%).height(44).bottom(20)
    }
    
    private func creatrLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            switch sectionKind {
            case .promo:       return self?.estimatedSectionLayout()
            case .images:      return self?.imagesSectionLayout()
            case .description: return self?.estimatedSectionLayout()
            case .property:    return self?.propertySectionLayout()
            case .details:     return self?.estimatedSectionLayout()
            case .actions:     return self?.estimatedSectionLayout() }
        })
    }
    
    private func imagesSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(0.8),
            heightDimension: .fractionalWidth(0.8)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    private func propertySectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(60)), subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }

    private func estimatedSectionLayout() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        return NSCollectionLayoutSection(group: group)
    }
}
