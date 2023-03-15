//
//  AlertViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.02.2023.
//

import UIKit
import Stevia

private class AlertViewController: UIViewController {
    
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
        label.font = UIFont.Oswald.bold.withSize(19)
        label.textAlignment = .center
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.Lato.regular.withSize(17)
        label.textAlignment = .center
        return label
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.Oswald.bold
        button.backgroundColor = .appRed
        button.setTitleColor(UIColor.appWhite, for: .normal)
        return button
    }()
    
    private let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.Oswald.bold
        button.backgroundColor = .appRed
        button.setTitleColor(UIColor.appWhite, for: .normal)
        return button
    }()
    
    lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 0
        stack.addArrangedSubview(cancelButton)
        stack.addArrangedSubview(confirmButton)
        return stack
    }()
    
    private let alertTitle: String?
    private let alertMessage: String?
    private let cancelButtonTitle: String?
    private let confirmButtonTitle: String?
    private let cancelAction: (() -> Void)?
    private let confirmAction: (() -> Void)?
    
    init(title: String, message: String?, cancelButtonTitle: String? = nil, confirmButtonTitle: String? = nil, cancelAction: (() -> Void)? = nil, confirmAction: (() -> Void)? = nil) {
        self.alertTitle = title
        self.alertMessage = message
        self.cancelButtonTitle = cancelButtonTitle
        self.confirmButtonTitle = confirmButtonTitle
        self.cancelAction = cancelAction
        self.confirmAction = confirmAction
        
        super.init(nibName: nil, bundle: nil)
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        
        self.titleLabel.text = alertTitle
        self.messageLabel.text = alertMessage
        
        self.confirmButton.setTitle(confirmButtonTitle ?? "OK", for: .normal)
        self.cancelButton.setTitle(cancelButtonTitle ?? "CANCEL", for: .normal)
        
        confirmButton.addAction { [weak self] in
            self?.confirmAction?()
            self?.dismiss(animated: true)
        }
        cancelButton.addAction { [weak self] in
            self?.cancelAction?()
            self?.dismiss(animated: true)
        }
    }
    
    private func configureLayout() {
        let contentStack = UIStackView()
        contentStack.axis = .vertical
        contentStack.alignment = .fill
        contentStack.distribution = .fill
        contentStack.spacing = 20
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(messageLabel)
        contentStack.addArrangedSubview(UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 18)))
        contentStack.addArrangedSubview(buttonStack)
        
        view.subviews(
            backgroundView,
            contentView.subviews(
                contentStack
            )
        )
        
        if confirmButtonTitle == nil, cancelButtonTitle == nil {
            buttonStack.isHidden = true
        } else if confirmButtonTitle != nil, cancelButtonTitle == nil {
            cancelButton.isHidden = true
            confirmButton.backgroundColor = .appBlack
        } else {
            cancelButton.backgroundColor = .appDarkGray
        }
        
        backgroundView.fillContainer()
        contentView.width(70%).centerInContainer()
        contentStack.top(20).fillHorizontally(padding: 12).bottom(12)
        cancelButton.height(44)
        confirmButton.height(44)
    }
}

extension UIViewController {
    
    func showAlert(title: String, message: String?, buttonTitle: String = "OK", action: (() -> Void)? = nil) {
        let alert = AlertViewController(title: title, message: message, confirmButtonTitle: buttonTitle, confirmAction: action)
        present(alert, animated: true)
    }
    
    func showBlockingAlert(title: String, message: String?) {
        let alert = AlertViewController(title: title, message: message)
        present(alert, animated: true)
    }
    
    func showDialogAlert(title: String, message: String?, confirmTitle: String = "OK", cancelTitle: String = "CANCEL", confirmAction: (() -> Void)? = nil) {
        let alert = AlertViewController(title: title, message: message, cancelButtonTitle: cancelTitle, confirmButtonTitle: confirmTitle, confirmAction: confirmAction)
        present(alert, animated: true)
    }
}
