//
//  PersonalDetailsViewController.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 13.03.2023.
//

import UIKit

protocol PersonalDetailsViewModel {
    var firstName: String { get set }
    var lastName: String { get set }
    var phoneNumber: String { get set }
    var shippingAddress: String { get set }
    var emailAddress: String { get }
    var password: String { get }
    var firstNameError: String? { get set }
    var lastNameError: String? { get set }
    var phoneError: String? { get set }
    var addressError: String? { get set }
}

class PersonalDetailsViewController: UIViewController {
    
    var configurator: PersonalDetailsConfigurator!
    var presenter: PersonalDetailsPresenter!
    var rootView: PersonalDetailsRootView!
    
    private var viewModel: PersonalDetailsViewModel? {
        didSet {
            rootView.firstNameTextField.text = viewModel?.firstName
            rootView.lastNameTextField.text = viewModel?.lastName
            rootView.phoneTextField.text = viewModel?.phoneNumber
            rootView.addressTextField.text = viewModel?.shippingAddress
            rootView.emailTextField.text = viewModel?.emailAddress
            rootView.passwordTextField.text = viewModel?.password
            if let error = viewModel?.firstNameError {
                self.viewModel?.firstNameError = nil
                rootView.firstNameTextField.triggerRequirements(with: error)
            }
            if let error = viewModel?.lastNameError {
                self.viewModel?.lastNameError = nil
                rootView.lastNameTextField.triggerRequirements(with: error)
            }
            if let error = viewModel?.phoneError {
                self.viewModel?.phoneError = nil
                rootView.phoneTextField.triggerRequirements(with: error)
            }
            if let error = viewModel?.addressError {
                self.viewModel?.addressError = nil
                rootView.addressTextField.triggerRequirements(with: error)
            }
        }
    }
    
    // MARK: - Life Cycle and overridden methods
    
    override func loadView() {
        configurator.configure(personalDetailsViewController: self)
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        Task { await presenter.viewDidLoad() }
    }
    
    private func setupViews() {
        hideKeyboardWhenTappedAround()
        observeKeyboardNotification(for: rootView.scrollView.bottomConstraint, adjustOffsetFor: rootView.scrollView)
        
        let button = UIButton(type: .system)
        button.setTitle("LOG OUT", for: .normal)
        button.setTitleColor(.appRed, for: .normal)
        button.titleLabel?.font = .Lato.medium
        button.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        // MARK: add TextField Actions
        rootView.firstNameTextField.addAction { [weak self] sender in
            self?.viewModel?.firstName = sender.text ?? ""
        }
        rootView.lastNameTextField.addAction { [weak self] sender in
            self?.viewModel?.lastName = sender.text ?? ""
        }
        rootView.phoneTextField.addAction { [weak self] sender in
            self?.viewModel?.phoneNumber = sender.text ?? ""
        }
        rootView.addressTextField.addAction { [weak self] sender in
            self?.viewModel?.shippingAddress = sender.text ?? ""
        }
        
        // MARK: add Button Actions
        rootView.editEmailButton.addAction { [weak self] in
            Task { await self?.presenter.editEmailButtonTapped() }
        }
        rootView.editPasswordButton.addAction { [weak self] in
            Task { await self?.presenter.editPasswordButtonTapped() }
        }
        rootView.saveButton.addAction { [weak self] in
            guard let self, let viewModel = self.viewModel as? PersonalDetailsModel else { return }
            Task { await self.presenter.saveButtonTapped(viewModel: viewModel) }
        }
    }
    
    @objc private func logoutButtonTapped() {
        showDialogAlert(title: "Confirm", message: "Are you sure you want to log out?", confirmTitle: "LOG OUT") { [weak self] in
            Task { await self?.presenter.logoutButtonTapped() }
        }
    }
}

extension PersonalDetailsViewController: PersonalDetailsView {
    
    func display(title: String) {
        self.title = title
    }
    
    func display(viewModel: PersonalDetailsModel) {
        self.viewModel = viewModel
    }
    
    func displayAlert(title: String, message: String?) {
        showAlert(title: title, message: message)
    }
    
    func displayError(title: String, message: String?) {
        showAlert(title: title, message: message)
    }
}
