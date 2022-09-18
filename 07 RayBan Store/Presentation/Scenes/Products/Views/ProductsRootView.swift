//
//  ProductsRootView.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 17.09.2022.
//

import Foundation
import Stevia

class ProductsRootView: UIView {
    
    let productsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.appWhite
        return collectionView
    }()
    
    // MARK: - Initializers and overridden methods

    init() {
        super.init(frame: .zero)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        subviews(
            productsCollectionView
        )
        
        productsCollectionView.width(100%).height(100%)
    }
}
