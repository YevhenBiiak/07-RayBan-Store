//
//  ActivityIndicatorView.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 24.02.2023.
//

import UIKit

class ActivityIndicatorView: UIView {
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let actInd = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        actInd.translatesAutoresizingMaskIntoConstraints = false
        actInd.style = .large
        actInd.color = .white
        return actInd
    }()
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black.withAlphaComponent(0.7)
        clipsToBounds = true
        layer.cornerRadius = 10
        
        // configure layout
        addSubview(activityIndicator)
        
        widthAnchor.constraint(equalToConstant: 80).isActive = true
        heightAnchor.constraint(equalToConstant: 80).isActive =  true
        
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive =  true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive =  true
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        self.removeFromSuperview()
    }
}
