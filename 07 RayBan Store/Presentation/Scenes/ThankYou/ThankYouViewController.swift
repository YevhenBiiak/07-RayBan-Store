//
//  ThankYouViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 10.03.2023.
//

import UIKit
import Stevia

class ThankYouViewController: UIViewController {
    
    private let backgroundView: UIView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurredView: UIView = UIVisualEffectView(effect: blurEffect)
        blurredView.alpha = 0.99
        return blurredView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .appWhite
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.Oswald.bold.withSize(22)
        label.textAlignment = .center
        label.text = "THANK YOU\n FOR YOUR ORDER"
        return label
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "wayfarer")
        return view
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .appDarkGray
        label.font = UIFont.Lato.regular
        label.textAlignment = .center
        label.text = "You can track the delivery in the “ORDER HISTORY” section."
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.Oswald.medium.withSize(18)
        button.backgroundColor = .appBlack
        button.setTitleColor(UIColor.appWhite, for: .normal)
        button.setTitle("CLOSE", for: .normal)
        return button
    }()
    
    init(onDismiss: (() -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
        
        let action = UIAction { [weak self] _ in
            self?.dismiss(animated: true, completion: onDismiss)
        }
        actionButton.addAction(action, for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
    }
    
    private func configureLayout() {
        
        view.subviews(
            backgroundView,
            contentView.subviews(
                imageView,
                titleLabel,
                messageLabel,
                actionButton
            )
        )
        
        backgroundView.fillContainer()
        contentView.width(80%).centerInContainer()
        titleLabel.width(90%).centerHorizontally().top(40)
        imageView.width(90%).heightEqualsWidth().centerHorizontally().Top == titleLabel.Bottom - 20
        messageLabel.width(90%).centerHorizontally().Top == imageView.Bottom - 40
        actionButton.width(50%).centerHorizontally().height(44).bottom(40).Top == messageLabel.Bottom + 50
    }
}
