//
//  AlertViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.02.2023.
//

import UIKit
import Stevia

class AlertViewController: UIViewController {
    
    private let backgroundView: UIView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurredView = UIVisualEffectView(effect: blurEffect)
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
        label.font = UIFont.Oswald.bold.withSize(20)
        label.textAlignment = .center
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.Lato.regular
        label.textAlignment = .center
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.Oswald.medium.withSize(18)
        button.backgroundColor = .appBlack
        button.setTitleColor(UIColor.appWhite, for: .normal)
        return button
    }()
    
    private let alertTitle: String?
    private let alertMessage: String?
    private let buttonTitle: String?
    private let completionHandler: (() -> Void)?
    
    init(title: String?, message: String?, buttonTitle: String?, completion: (() -> Void)?) {
        self.alertTitle = title
        self.alertMessage = message
        self.buttonTitle = buttonTitle
        self.completionHandler = completion
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        
        self.titleLabel.text = alertTitle
        self.messageLabel.text = alertMessage
        self.actionButton.setTitle(buttonTitle ?? "OK", for: .normal)
        
        actionButton.addTarget(self, action: #selector(dismissAlertController), for: .touchUpInside)
    }
    
    @objc private func dismissAlertController() {
        dismiss(animated: true, completion: completionHandler)
    }
    
    private func configureLayout() {
        if buttonTitle == nil {
            view.subviews(
                backgroundView,
                contentView.subviews(
                    titleLabel,
                    messageLabel
                )
            )
            
            backgroundView.fillContainer()
            contentView.width(70%).centerInContainer()
            titleLabel.width(90%).centerHorizontally().top(20)
            messageLabel.width(90%).centerHorizontally().bottom(20).Top == titleLabel.Bottom + 20
            
        } else {
            view.subviews(
                backgroundView,
                contentView.subviews(
                    titleLabel,
                    messageLabel,
                    actionButton
                )
            )
            
            backgroundView.fillContainer()
            contentView.width(70%).centerInContainer()
            titleLabel.width(90%).centerHorizontally().top(20)
            messageLabel.width(90%).centerHorizontally().Top == titleLabel.Bottom + 20
            actionButton.fillHorizontally().height(44).bottom(0) .Top == messageLabel.Bottom + 30
        }
    }
}

extension UIViewController {
    
    func showAlert(title: String?, message: String?, buttonTitle: String?, completion: (() -> Void)? = nil) {
        let alertViewController = AlertViewController(title: title, message: message, buttonTitle: buttonTitle, completion: completion)
        present(alertViewController, animated: true)
    }
}
