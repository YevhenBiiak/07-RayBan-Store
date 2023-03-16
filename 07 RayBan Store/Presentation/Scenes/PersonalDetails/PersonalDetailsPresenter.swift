//
//  PersonalDetailsPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 13.03.2023.
//

@MainActor
protocol PersonalDetailsRouter {
    func presentLoginScene()
    func presentEditEmail(onSuccess: (() async -> Void)?)
    func presentEditPassword()
}

@MainActor
protocol PersonalDetailsView: AnyObject {
    func display(title: String)
    func display(viewModel: PersonalDetailsModel)
    func displayAlert(title: String, message: String?)
    func displayError(title: String, message: String?)
}

protocol PersonalDetailsPresenter {
    func viewDidLoad() async
    func logoutButtonTapped() async
    func editEmailButtonTapped() async
    func editPasswordButtonTapped() async
    func saveButtonTapped(viewModel: PersonalDetailsModel) async
}

class PersonalDetailsPresenterImpl {
    
    private weak var view: PersonalDetailsView?
    private let router: PersonalDetailsRouter
    private let authUseCase: AuthUseCase
    private let profileUseCase: ProfileUseCase
    
    private var profile: Profile!
    
    init(view: PersonalDetailsView? = nil, router: PersonalDetailsRouter, authUseCase: AuthUseCase, profileUseCase: ProfileUseCase) {
        self.view = view
        self.router = router
        self.authUseCase = authUseCase
        self.profileUseCase = profileUseCase
    }
}

extension PersonalDetailsPresenterImpl: PersonalDetailsPresenter {
    
    func viewDidLoad() async {
        await with(errorHandler) {
            let request = GetProfileRequest(user: Session.shared.user)
            profile = try await profileUseCase.execute(request)
            await view?.display(title: "\(profile.firstName ?? "") \(profile.lastName ?? "")")
            let viewModel = createPersonalDetailsModel(with: profile)
            await view?.display(viewModel: viewModel)
        }
    }
    
    func logoutButtonTapped() async {
        await with(errorHandler) {
            try authUseCase.executeLogoutRequest()
            await router.presentLoginScene()
        }
    }
    
    func editEmailButtonTapped() async {
        await router.presentEditEmail(onSuccess: viewDidLoad)
    }
    
    func editPasswordButtonTapped() async {
        await router.presentEditPassword()
    }
    
    func saveButtonTapped(viewModel: PersonalDetailsModel) async {
        await with(errorHandler) {
            // update fields
            profile.firstName = viewModel.firstName
            profile.lastName = viewModel.lastName
            profile.email = viewModel.emailAddress
            profile.phone = viewModel.phoneNumber
            profile.address = viewModel.shippingAddress
            
            let request = SaveProfileRequest(user: Session.shared.user, profile: profile)
            try await profileUseCase.execute(request)
            await view?.displayAlert(title: "Success", message: "All your changes have been saved")
        }
    }
}

// MARK: - Private extension

private extension PersonalDetailsPresenterImpl {
    
    func displayUpdatedPersonalDetails(
        firstNameError: String? = nil,
        lastNameError: String? = nil,
        emailError: String? = nil,
        phoneError: String? = nil,
        addressError: String? = nil
    ) async {
        var model = createPersonalDetailsModel(with: profile)
        model.firstNameError = firstNameError
        model.lastNameError = lastNameError
        model.phoneError = phoneError
        model.addressError = addressError
        
        await view?.display(viewModel: model)
    }
    
    func createPersonalDetailsModel(with profile: Profile) -> PersonalDetailsModel {
        .init(
            firstName: profile.firstName ?? "",
            lastName: profile.lastName ?? "",
            phoneNumber: profile.phone ?? "",
            shippingAddress: profile.address ?? "",
            emailAddress: profile.email,
            password: "12345678" // placeholder
        )
    }
    
    func errorHandler(_ error: Error) async {
        if let error = error as? AppError {
            switch error {
            case .networkError:          await view?.displayError(title: "Error", message: error.localizedDescription)

            case .firstNameValueIsEmpty: await displayUpdatedPersonalDetails(firstNameError: error.localizedDescription)
                
            case .lastNameValueIsEmpty:  await displayUpdatedPersonalDetails(lastNameError: error.localizedDescription)
            
            case .emailValueIsEmpty,
                 .emailFormatIsWrong:    await displayUpdatedPersonalDetails(emailError: error.localizedDescription)
            
            case .phoneValueIsEmpty,
                 .phoneFormatIsWrong:    await displayUpdatedPersonalDetails(phoneError: error.localizedDescription)
            
            case .addressValueIsEmpty,
                 .addressFormatIsWrong:  await displayUpdatedPersonalDetails(addressError: error.localizedDescription)
            
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
