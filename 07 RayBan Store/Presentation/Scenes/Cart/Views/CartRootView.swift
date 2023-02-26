//
//  CartRootView.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 25.02.2023.
//

import UIKit

class CartRootView: UIView {
    
    // MARK: - Initializers and overridden methods

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
    }
    
    private func configureLayout() {
        
    }
}
