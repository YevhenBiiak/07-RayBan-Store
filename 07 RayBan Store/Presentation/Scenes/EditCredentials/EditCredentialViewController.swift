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
    
    var viewModel: EditCredentialModel? {
        didSet {
            rootView.titleLabel.text = viewModel?.title
            rootView.subtitleLabel.text = viewModel?.subtitle
            rootView.newValueTextField.setAttributedPlaceholder(text: viewModel?.newValuePlaceholder)
            rootView.confirmValueTextField.setAttributedPlaceholder(text: viewModel?.confirmValuePlaceholder)
        }
    }
    
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
        
        rootView.confirmButton.addAction { [weak self] in
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
    
    func display(viewModel: EditCredentialModel) {
        self.viewModel = viewModel
    }
    
    func display(newValueFieldError: String) {
        rootView.newValueTextField.triggerRequirements(with: newValueFieldError)
    }
    
    func display(confirmValueFieldError: String) {
        rootView.confirmValueTextField.triggerRequirements(with: confirmValueFieldError)
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
    func displayAlert(title: String, message: String?) {
        
    }
    
    func displayError(title: String, message: String?) {
        showAlert(title: title, message: message)
    }
}
