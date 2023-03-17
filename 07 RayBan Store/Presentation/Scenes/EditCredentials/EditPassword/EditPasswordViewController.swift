//
//  EditPasswordViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 17.03.2023.
//

import UIKit

class EditPasswordViewController: UIViewController {
    
    var configurator: EditPasswordConfigurator!
    var presenter: EditPasswordPresenter!
    var rootView: EditPasswordRootView!
    
    // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(editPasswordViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
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
        
        rootView.confirmButton.addAction { [weak self] in
            Task { await self?.presenter.saveButtonTapped(
                newPassword: self?.rootView.newPasswordTextField.text ?? "",
                confirmPassword: self?.rootView.confirmPasswordTextField.text ?? "",
                currentPassword: self?.rootView.currentPasswordTextField.text ?? ""
            )}
        }
    }
    
    @objc private func closeButtonTapped() {
        Task { await presenter.closeButtonTapped() }
    }
}

extension EditPasswordViewController: EditPasswordView {
    
    func display(newPasswordFieldError: String) {
        rootView.newPasswordTextField.triggerRequirements(with: newPasswordFieldError)
    }
    
    func display(confirmPasswordFieldError: String) {
        rootView.confirmPasswordTextField.triggerRequirements(with: confirmPasswordFieldError)
    }
    
    func display(currentPasswordFieldError: String) {
        rootView.currentPasswordTextField.triggerRequirements(with: currentPasswordFieldError)
    }
    
    func display(activityIndicator show: Bool) {
        rootView.confirmButton.configuration?.showsActivityIndicator = show
    }
    
    func displayWarning(message: String) {
        showWarning(with: message)
    }
    
    func displayDialogAlert(title: String, message: String?, confirmAction: @escaping () async -> Void) {
        showDialogAlert(title: title, message: message, confirmTitle: "YES", cancelTitle: "CONTINUE") {
            Task { await confirmAction() }
        }
    }
    
    func displayAlert(title: String, message: String?, completion: @escaping () async -> Void) {
        showAlert(title: title, message: message, action: {
            Task { await completion() }
        })
    }
    
    func displayError(title: String, message: String?) {
        showAlert(title: title, message: message)
    }
}
