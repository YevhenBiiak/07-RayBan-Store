//
//  EditEmailViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 16.03.2023.
//

import UIKit

class EditEmailViewController: UIViewController {
    
    var configurator: EditEmailConfigurator!
    var presenter: EditEmailPresenter!
    var rootView: EditEmailRootView!
    
    // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(editEmailViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    private func setupActions() {
        observeKeyboardNotification(for: rootView.contentView.centerYConstraint)
        
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
                newEmail: self?.rootView.newEmailTextField.text ?? "",
                confirmEmail: self?.rootView.confirmEmailTextField.text ?? "",
                password: self?.rootView.passwordTextField.text ?? ""
            )}
        }
    }
    
    @objc private func closeButtonTapped() {
        Task { await presenter.closeButtonTapped() }
    }
}

extension EditEmailViewController: EditEmailView {
    
    func display(newEmailFieldError: String) {
        rootView.newEmailTextField.triggerRequirements(with: newEmailFieldError)
    }
    
    func display(confirmEmailFieldError: String) {
        rootView.confirmEmailTextField.triggerRequirements(with: confirmEmailFieldError)
    }
    
    func display(passwordFieldError: String) {
        rootView.passwordTextField.triggerRequirements(with: passwordFieldError)
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
