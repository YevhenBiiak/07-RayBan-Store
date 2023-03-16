//
//  EditCredentialViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 16.03.2023.
//

import UIKit

class EditCredentialsViewController: UIViewController {
    
    var configurator: EditCredentialsConfigurator!
    var presenter: EditCredentialsPresenter!
    var rootView: EditCredentialsRootView!
    
    // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(editCredentialsViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        Task { await presenter.viewDidLoad() }
    }
    
    private func setupActions() {
        
        // Add tap gestures
        let tapContentView: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        rootView.contentView.addGestureRecognizer(tapContentView)
        
        let tapAroundContent: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        rootView.addGestureRecognizer(tapAroundContent)
        
        // Add Button Actions
        rootView.closeButton.addAction { [weak self] in
            self?.closeButtonTapped()
        }
        
        rootView.saveButton.addAction { [weak self] in
            Task { await self?.presenter.saveButtonTapped(
                newValue: self?.rootView.newValueTextField.text ?? "",
                confirmValue: self?.rootView.confirmValueTextField.text ?? "",
                password: self?.rootView.passwordTextField.text ?? ""
            )}
        }
    }
    
    @objc private func closeButtonTapped() {
        Task { await presenter.closeButtonTapped() }
    }
}

extension EditCredentialsViewController: EditCredentialsView {
    
    func display(title: String) {
        rootView.titleLabel.text = title
    }
    
    func display(subtitle: String) {
        rootView.subtitleLabel.text = subtitle
    }
    
    func display(newValuePlaceholder: String) {
        rootView.newValueTextField.setAttributedPlaceholder(text: newValuePlaceholder)
    }
    
    func display(confirmValuePlaceholder: String) {
        rootView.confirmValueTextField.setAttributedPlaceholder(text: confirmValuePlaceholder)
    }
    
    func displayDialogAlert(title: String, message: String?, confirmAction: @escaping () async -> Void) {
        showDialogAlert(title: title, message: message, confirmTitle: "YES", cancelTitle: "CONTINUE") {
            Task { await confirmAction() }
        }
    }
    
    func display(newValueFiledError: String) {
        rootView.newValueTextField.triggerRequirements(with: newValueFiledError)
    }
    
    func display(confirmValueFiledError: String) {
        rootView.confirmValueTextField.triggerRequirements(with: confirmValueFiledError)
    }
    
    func display(passwordFiledError: String) {
        rootView.passwordTextField.triggerRequirements(with: passwordFiledError)
    }
    
    func displayWarning(message: String) {
        showWarning(with: message)
    }
    
    func displayAlert(title: String, message: String?, completion: @escaping () async -> Void) {
        showAlert(title: title, message: message, action: {
            Task { await completion() }
        })
    }
    func displayAlert(title: String, message: String?) {
        
    }
    
    func displayError(title: String, message: String?) {
        showAlert(title: title, message: message)
    }
}
