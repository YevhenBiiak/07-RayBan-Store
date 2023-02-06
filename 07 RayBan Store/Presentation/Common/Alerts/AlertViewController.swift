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

extension UIViewController {
    
    func showAlert(title: String?, message: String?, buttonTitle: String? = nil, completion: (() -> Void)? = nil) {
        let alertViewController = AlertViewController(title: title, message: message, buttonTitle: buttonTitle, completion: completion)
        present(alertViewController, animated: true)
    }
    
    func showWarning(with text: String) {
        // create views
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.backgroundColor = .appRed

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .appWhite
        label.numberOfLines = 0
        label.text = text
        
        // configure layout
        content.addSubview(label)
        view.addSubview(content)
        
        label.topAnchor.constraint(equalTo: content.topAnchor, constant: 8).isActive = true
        label.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -8).isActive = true
        label.leftAnchor.constraint(equalTo: content.leftAnchor, constant: 8).isActive = true
        label.rightAnchor.constraint(equalTo: content.rightAnchor, constant: -8).isActive = true
        
        content.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        content.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        content.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        content.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // layout content subviews
        content.layoutIfNeeded()
        content.topConstraint?.constant = -content.frame.height
        
        // animate
        content.alpha = 0
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            content.alpha = 1
            content.topConstraint?.constant = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.3, delay: 4) {
                content.alpha = 0
                content.topConstraint?.constant = -content.frame.height
                self.view.layoutIfNeeded()
            } completion: { _ in
                content.removeFromSuperview()
            }
        }
    }
}
