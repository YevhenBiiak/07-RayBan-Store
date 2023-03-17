//
//  EditEmailPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 16.03.2023.
//

@MainActor
protocol EditEmailView: AnyObject {
    func display(newEmailFieldError: String)
    func display(confirmEmailFieldError: String)
    func display(passwordFieldError: String)
    func display(activityIndicator show: Bool)
    func displayWarning(message: String)
    func displayDialogAlert(title: String, message: String?, confirmAction: @escaping () async -> Void)
    func displayAlert(title: String, message: String?, completion: @escaping () async -> Void)
    func displayError(title: String, message: String?)
}

protocol EditEmailPresenter {
    func closeButtonTapped() async
    func saveButtonTapped(newEmail: String, confirmEmail: String, password: String) async
}

class EditEmailPresenterImpl {
    
    private weak var view: EditEmailView?
    private let router: EditCredentialsRouter
    private let authUseCase: AuthUseCase
    private let successHandler: (() async -> Void)?
    
    init(view: EditEmailView?, router: EditCredentialsRouter, authUseCase: AuthUseCase, successHandler: (() async -> Void)?) {
        self.view = view
        self.router = router
        self.authUseCase = authUseCase
        self.successHandler = successHandler
    }
}

extension EditEmailPresenterImpl: EditEmailPresenter {
    
    func saveButtonTapped(newEmail: String, confirmEmail: String, password: String) async {
        await with(errorHandler) {
            // show activity indicator and hide when error or success occurred
            await view?.display(activityIndicator: true)
            defer { Task { await view?.display(activityIndicator: false) }}
            
            let request = UpdateEmailRequest(user: Session.shared.user, newEmail: newEmail, confirmEmail: confirmEmail, password: password)
            try await authUseCase.execute(request)
            await successHandler?()
            await view?.displayAlert(title: "Success", message: "Your email address have been changed to: \(newEmail)") { [weak self] in
                await self?.router.dismiss(animated: true)
            }
        }
    }
    
    func closeButtonTapped() async {
        await view?.displayDialogAlert(
            title: "CANCEL EMAIL CHANGE",
            message: "Are you sure you want to cancel the email change?",
            confirmAction: { [weak self] in
                await self?.router.dismiss(animated: true)
            }
        )
    }
}

// MARK: - Private extension

private extension EditEmailPresenterImpl {

    func errorHandler(_ error: Error) async {
        if let error = error as? AppError {
            switch error {
            case .networkError:          await view?.displayError(title: "Error", message: error.localizedDescription)

            case .emailValueIsEmpty,
                 .emailFormatIsWrong,
                 .invalidEmail:          await view?.display(newEmailFieldError: error.localizedDescription)

            case .passwordValueIsEmpty,
                 .passwordLengthIsWrong,
                 .weakPassword:          await view?.display(passwordFieldError: error.localizedDescription)

            case .valuesDoNotMatch:      await view?.display(confirmEmailFieldError: error.localizedDescription)

            case .emailAlreadyInUse:      await view?.displayWarning(message: error.localizedDescription)

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
