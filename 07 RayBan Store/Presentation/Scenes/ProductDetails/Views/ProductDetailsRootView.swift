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
        case images
        case description
        case property
        case details
        case actions
    }
    
    let promoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.appBlack
        label.textColor = UIColor.appWhite
        label.textAlignment = .center
        label.text = "Enjoy Free Shipping on all orders."
        return label
    }()
    
    let trailingBuyButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.Oswald.regular
        button.tintColor = UIColor.appWhite
        button.backgroundColor = UIColor.appRed
        return button
    }()
    
    var productDetailsCollectionView: UICollectionView!

    // MARK: - Initializers and overridden methods

    init() {
        super.init(frame: .zero)
        setupCollectinView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPriceForTrailingButton(price: Int) {
        let formattedPrice = String(format: "%.2f", Double(price))
        trailingBuyButton.setTitle("SHOP - $ \(formattedPrice)", for: .normal)
    }
    
    func getNumberOfSections() -> Int {
        Section.allCases.count
    }
    
    func getSectionKind(forSection section: Int) -> ProductDetailsRootView.Section? {
        Section(rawValue: section)
    }
    
    // MARK: - Private methods
    
    private func setupCollectinView() {
        productDetailsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: creatrLayout())
        
        subviews(
            productDetailsCollectionView,
            promoLabel,
            trailingBuyButton
        )
        
        promoLabel.width(100%).height(35).top(92)
        productDetailsCollectionView.width(100%).height(100%)
        trailingBuyButton.centerHorizontally().width(90%).height(44).bottom(20)
    }
    
    private func creatrLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (sectionIndex: Int, _: NSCollectionLayoutEnvironment) in
            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            
            switch sectionKind {
            case .images: return self?.imagesSectionLayout()
            case .description: return self?.descriptionSectionLayout()
            case .property: return self?.propertySectionLayout()
            case .details: return self?.detailsSectionLayout()
            case .actions: return self?.actionsSectionLayout()
            }
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
    private func descriptionSectionLayout() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(130))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        return NSCollectionLayoutSection(group: group)
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
    private func detailsSectionLayout() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        return NSCollectionLayoutSection(group: group)
    }
    private func actionsSectionLayout() -> NSCollectionLayoutSection {
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: 1)
        return NSCollectionLayoutSection(group: group)
    }
}
