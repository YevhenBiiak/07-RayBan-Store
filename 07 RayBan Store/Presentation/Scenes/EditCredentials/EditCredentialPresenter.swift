//
//  EditCredentialPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 16.03.2023.
//

@MainActor
protocol EditCredentialsRouter {
    func dismiss(animated: Bool)
}

@MainActor
protocol EditCredentialsView: AnyObject {
    func display(viewModel: EditCredentialModel)
    func display(newValueFieldError: String)
    func display(confirmValueFieldError: String)
    func display(passwordFieldError: String)
    func display(activityIndicator show: Bool)
    func displayWarning(message: String)
    func displayDialogAlert(title: String, message: String?, confirmAction: @escaping () async -> Void)
    func displayAlert(title: String, message: String?, completion: @escaping () async -> Void)
    func displayError(title: String, message: String?)
}

protocol EditCredentialsPresenter {
    func viewDidLoad() async
    func closeButtonTapped() async
    func saveButtonTapped(newValue: String, confirmValue: String, password: String) async
}

enum CredentialType { case email, password }

class EditCredentialsPresenterImpl {
    
    private weak var view: EditCredentialsView?
    private let router: EditCredentialsRouter
    private let authUseCase: AuthUseCase
    private let changeType: CredentialType
    private let successCompletion: (() async -> Void)?
    
    init(view: EditCredentialsView?, router: EditCredentialsRouter, authUseCase: AuthUseCase, changeType: CredentialType, successCompletion: (() async -> Void)?) {
        self.view = view
        self.router = router
        self.authUseCase = authUseCase
        self.changeType = changeType
        self.successCompletion = successCompletion
    }
}

extension EditCredentialsPresenterImpl: EditCredentialsPresenter {
    
    func viewDidLoad() async {
        switch changeType {
        case .email:
            await view?.display(viewModel: editEmailModel())
        case .password:
            await view?.display(viewModel: editPasswordModel())
        }
    }
    
    func saveButtonTapped(newValue: String, confirmValue: String, password: String) async {
        await with(errorHandler) {
            // show activity indicator and hide when error or success occurred
            await view?.display(activityIndicator: true)
            defer { Task { await view?.display(activityIndicator: false) }}
            
            // make change request
            switch changeType {
            case .email:
                let request = UpdateEmailRequest(user: Session.shared.user, newEmail: newValue, confirmEmail: confirmValue, password: password)
                try await authUseCase.execute(request)
                await successCompletion?()
                await view?.displayAlert(title: "Success", message: "Your email address have been changed to: \(newValue)") { [weak self] in
                    await self?.router.dismiss(animated: true)
                }
            case .password:
                let request = UpdatePasswordRequest(user: Session.shared.user, newPassword: newValue, confirmPassword: confirmValue, accountPassword: password)
                try await authUseCase.execute(request)
                await successCompletion?()
                await view?.displayAlert(title: "Success", message: "Your password have been changed") { [weak self] in
                    await self?.router.dismiss(animated: true)
                }
            }
        }
    }
    
    func closeButtonTapped() async {
        let title, message: String
        switch changeType {
        case .email:
            title =  "CANCEL EMAIL CHANGE"
            message = "Are you sure you want to cancel the email change?"
        case .password:
            title = "CANCEL PASSWORD CHANGE"
            message = "Are you sure you want to cancel the password change?"
        }
        await view?.displayDialogAlert(
            title: title,
            message: message,
            confirmAction: { [weak self] in
                await self?.router.dismiss(animated: true)
            }
        )
    }
}

// MARK: - Private extension

private extension EditCredentialsPresenterImpl {
    
    func editEmailModel() -> EditCredentialModel {
        .init(
            title: "CHANGE EMAIL ADDRESS",
            subtitle: "This is the e-mail you use to login to the app.",
            newValuePlaceholder: "New email address*",
            confirmValuePlaceholder: "Confirm new email address*"
        )
    }
    
    func editPasswordModel() -> EditCredentialModel {
        .init(
            title: "CHANGE PASSWORD",
            subtitle: "This is the password you use to login to the app.",
            newValuePlaceholder: "New password*",
            confirmValuePlaceholder: "Confirm new password*"
        )
    }
    
    func errorHandler(_ error: Error) async {
        if let error = error as? AppError {
            switch error {
            case .networkError:          await view?.displayError(title: "Error", message: error.localizedDescription)
            
            case .emailValueIsEmpty,
                 .emailFormatIsWrong,
                 .invalidEmail:          await view?.display(newValueFieldError: error.localizedDescription)
                
            case .passwordValueIsEmpty,
                 .passwordLengthIsWrong,
                 .weakPassword:          await view?.display(passwordFieldError: error.localizedDescription)
                
            case .valuesDoNotMatch:      await view?.display(confirmValueFieldError: error.localizedDescription)
                
            case .emailAlreadyInUse,
                 .wrongPassword,
                 .facebookError,
                 .notAcceptedPolicy:     await view?.displayWarning(message: error.localizedDescription)
                
            case .permissionsDenied:     await view?.displayError(title: "Error", message: error.localizedDescription)
                
            case .unknown:
                fatalError(error.localizedDescription)
            default:
                print("irrelevant error for Registration:", error.localizedDescription)
            }
            return
        }
        fatalError("Unhandled error type: \(String(describing: error)) \(error.localizedDescription)")
    }
}
