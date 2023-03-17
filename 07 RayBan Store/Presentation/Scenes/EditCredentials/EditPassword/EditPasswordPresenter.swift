//
//  EditPasswordPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 17.03.2023.
//

@MainActor
protocol EditPasswordView: AnyObject {
    func display(newPasswordFieldError: String)
    func display(confirmPasswordFieldError: String)
    func display(currentPasswordFieldError: String)
    func display(activityIndicator show: Bool)
    func displayWarning(message: String)
    func displayDialogAlert(title: String, message: String?, confirmAction: @escaping () async -> Void)
    func displayAlert(title: String, message: String?, completion: @escaping () async -> Void)
    func displayError(title: String, message: String?)
}

protocol EditPasswordPresenter {
    func closeButtonTapped() async
    func saveButtonTapped(newPassword: String, confirmPassword: String, currentPassword: String) async
}

class EditPasswordPresenterImpl {
    
    private weak var view: EditPasswordView?
    private let router: EditCredentialsRouter
    private let authUseCase: AuthUseCase
    
    init(view: EditPasswordView?, router: EditCredentialsRouter, authUseCase: AuthUseCase) {
        self.view = view
        self.router = router
        self.authUseCase = authUseCase
    }
}

extension EditPasswordPresenterImpl: EditPasswordPresenter {
    
    func saveButtonTapped(newPassword: String, confirmPassword: String, currentPassword: String) async {
        await with(errorHandler) {
            // show activity indicator and hide when error or success occurred
            await view?.display(activityIndicator: true)
            defer { Task { await view?.display(activityIndicator: false) }}
            
            let request = UpdatePasswordRequest(
                user: Session.shared.user,
                newPassword: newPassword,
                confirmPassword: confirmPassword,
                accountPassword: currentPassword
            )
            try await authUseCase.execute(request)
            await view?.displayAlert(title: "Success", message: "Your password have been changed") { [weak self] in
                await self?.router.dismiss(animated: true)
            }
        }
    }
    
    func closeButtonTapped() async {
        await view?.displayDialogAlert(
            title: "CANCEL PASSWORD CHANGE",
            message: "Are you sure you want to cancel the password change?",
            confirmAction: { [weak self] in
                await self?.router.dismiss(animated: true)
            }
        )
    }
}

// MARK: - Private extension

private extension EditPasswordPresenterImpl {
    
    func errorHandler(_ error: Error) async {
        if let error = error as? AppError {
            switch error {
            case .networkError:          await view?.displayError(title: "Error", message: error.localizedDescription)

            case .passwordValueIsEmpty,
                 .passwordLengthIsWrong,
                 .weakPassword:          await view?.display(currentPasswordFieldError: error.localizedDescription)

            case .valuesDoNotMatch:      await view?.display(confirmPasswordFieldError: error.localizedDescription)

            case .wrongPassword:         await view?.displayWarning(message: error.localizedDescription)

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
