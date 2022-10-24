//
//  ShimmerView.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 24.10.2022.
//

import UIKit

class ShimmerView: UIView {

    let firstColor = UIColor.appLightGray.cgColor
    let secondColor = UIColor.appWhite.cgColor
    
    private let animation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 0.9
        return animation
    }()
    
    init() {
        super.init(frame: .zero)
        if let layer = layer as? CAGradientLayer {
            layer.startPoint = CGPoint(x: 0.0, y: 1.0)
            layer.endPoint = CGPoint(x: 1.0, y: 1.0)
            layer.colors = [firstColor, secondColor, firstColor]
            layer.locations = [0.0, 0.5, 1.0]
        }
        isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }
    
    func startShimmerAnimating() {
        self.isHidden = false
        layer.add(animation, forKey: animation.keyPath)
    }

    func stopShimmerAnimating() {
        self.isHidden = true
        layer.removeAllAnimations()
    }
}
