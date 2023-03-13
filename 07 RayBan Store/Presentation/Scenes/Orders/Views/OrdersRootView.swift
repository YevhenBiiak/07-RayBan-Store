//
//  OrdersRootView.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 11.03.2023.
//

import UIKit
import Stevia

class OrdersRootView: UIView {
    
    var сollectionView: UICollectionView!
    
    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.image = UIImage(named: "image_placeholder")
        view.title = "There are no orders in your order history."
        return view
    }()
    
    // MARK: - Initializers and overridden methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: - Private methods
    
    private func setupViews() {
        сollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        emptyStateView.observeCollectionView(сollectionView)
    }
    
    private func configureLayout() {
        
        subviews(
            сollectionView.subviews(
                emptyStateView
            )
        )
        
        сollectionView.fillContainer()
        emptyStateView.Left == safeAreaLayoutGuide.Left
        emptyStateView.Right == safeAreaLayoutGuide.Right
        emptyStateView.Top == safeAreaLayoutGuide.Top
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(95)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(95)),
            subitems: [item])
        
        return UICollectionViewCompositionalLayout(section: .init(group: group))
    }
}
