//
//  CheckoutPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.03.2023.
//

import Foundation

@MainActor
protocol CheckoutRouter {
    func returnToProducts()
}

@MainActor
protocol CheckoutView: AnyObject {
    func display(title: String)
    func display(itemsSection: any Sectionable)
    func display(orderDetails: OrderDetailsViewModel)
    func display(deliveryInfo: DeliveryInfoViewModel)
    func displayError(title: String, message: String?)
}

protocol CheckoutPresenter {
    func viewDidLoad() async
}

class CheckoutPresenterImpl {
    
    private weak var view: CheckoutView?
    private let router: CheckoutRouter
    private let cartUseCase: CartUseCase
    private let profileUseCase: ProfileUseCase
    
    private let shippingMethod: ShippingMethod
    private var currentDeliveryInfo: DeliveryInfoViewModel!
    
    init(shippingMethod: ShippingMethod,
         view: CheckoutView?,
         router: CheckoutRouter,
         cartUseCase: CartUseCase,
         profileUseCase: ProfileUseCase
    ) {
        self.shippingMethod = shippingMethod
        self.view = view
        self.router = router
        self.cartUseCase = cartUseCase
        self.profileUseCase = profileUseCase
    }
}

extension CheckoutPresenterImpl: CheckoutPresenter {
    
    func viewDidLoad() async {
        await with(errorHandler) {
            await view?.display(title: "CHECKOUT")
            let request = GetCartItemsRequest(user: Session.shared.user)
            let cartItems = try await cartUseCase.execute(request)
            let viewModels = cartItems.map(createOrderItemModel)
            let items = viewModels.map(OrderSectionItem.init)
            let section = OrderItemsSection(items: items)
            await view?.display(itemsSection: section)
            
            let summaryRequest = OrderSummaryRequest(user: Session.shared.user, shippingMethod: shippingMethod)
            let orderSummary = try await cartUseCase.execute(summaryRequest)
            let orderDetails = createOrderDetailsModel(with: orderSummary)
            await view?.display(orderDetails: orderDetails)
            
            let profileRequest = GetProfileRequest(user: Session.shared.user)
            let profile = try await profileUseCase.execute(profileRequest)
            currentDeliveryInfo = createDeliveryInfoModel(with: profile)
            await view?.display(deliveryInfo: currentDeliveryInfo)
        }
    }
}

// MARK: - Private extension

private extension CheckoutPresenterImpl {
    
    private func createOrderItemModel(with cartItem: CartItem) -> OrderItemModel? {
        guard let variation = cartItem.product.variations.first else { return nil }
        return OrderItemModel(
            productID: variation.productID,
            name: cartItem.product.name.uppercased(),
            price: "$ " + String(format: "%.2f", Double(variation.price) / 100.0),
            quantity: "Quantity: \(cartItem.amount)",
            imageData: variation.imageData?.first ?? Data()
        )
    }
    
    private func createOrderDetailsModel(with orderSummary: OrderSummary) -> OrderDetailsModel {
        OrderDetailsModel(
            shippingTitle: shippingMethod.name,
            shippingSubtitle: shippingMethod.duration,
            shippingPrice: shippingMethod.price == 0 ? "FREE" : "$ " + String(format: "%.2f", Double(shippingMethod.price) / 100.0),
            orderSubtotal: "$ " + String(format: "%.2f", Double(orderSummary.subtotal) / 100.0),
            orderShippingCost: "$ " + String(format: "%.2f", Double(orderSummary.shipping) / 100.0),
            orderTotal: "$ " + String(format: "%.2f", Double(orderSummary.total) / 100.0)
        )
    }
    
    private func createDeliveryInfoModel(with profile: Profile) -> DeliveryInfoModel {
        DeliveryInfoModel(
            firstName: profile.firstName ?? "",
            lastName: profile.lastName ?? "",
            emailAddress: profile.email,
            phoneNumber: profile.phone ?? "",
            shippingAddress: profile.address ?? "",
            paymentButtonTapped: { [weak self] viewModel in
                await self?.paymentButtonTapped(viewModel: viewModel)
            }
        )
    }
    
    private func displayUpdatedDeliveryInfo(
        firstNameError: String? = nil,
        lastNameError: String? = nil,
        emailError: String? = nil,
        phoneError: String? = nil,
        addressError: String? = nil
    ) async {
        let updatedDeliveryInfo = DeliveryInfoModel(
            firstName: currentDeliveryInfo.firstName,
            lastName: currentDeliveryInfo.lastName,
            emailAddress: currentDeliveryInfo.emailAddress,
            phoneNumber: currentDeliveryInfo.phoneNumber,
            shippingAddress: currentDeliveryInfo.shippingAddress,
            firstNameError: firstNameError,
            lastNameError: lastNameError,
            emailError: emailError,
            phoneError: phoneError,
            addressError: addressError,
            paymentButtonTapped: { [weak self] viewModel in
                await self?.paymentButtonTapped(viewModel: viewModel)
            }
        )
        await view?.display(deliveryInfo: updatedDeliveryInfo)
    }
    
    private func paymentButtonTapped(viewModel: DeliveryInfoViewModel) async {
        await with(errorHandler) {
            currentDeliveryInfo = viewModel
            let info = DeliveryInfo(
                firstName: viewModel.firstName,
                lastName: viewModel.lastName,
                emailAddress: viewModel.emailAddress,
                phoneNumber: viewModel.phoneNumber,
                shippingAddress: viewModel.shippingAddress
            )
            let request = CreateOrderRequest(user: Session.shared.user, shippingMethod: shippingMethod, deliveryInfo: info)
            try await cartUseCase.execute(request)
            // present thanks screen
            await router.returnToProducts()
        }
    }
    
    private func errorHandler(_ error: Error) async {
        if let error = error as? AppError {
            switch error {
            case .networkError:          await view?.displayError(title: "Error", message: error.localizedDescription)

            case .firstNameValueIsEmpty: await displayUpdatedDeliveryInfo(firstNameError: error.localizedDescription)
                
            case .lastNameValueIsEmpty:  await displayUpdatedDeliveryInfo(lastNameError: error.localizedDescription)
            
            case .emailValueIsEmpty,
                 .emailFormatIsWrong:    await displayUpdatedDeliveryInfo(emailError: error.localizedDescription)
            
            case .phoneValueIsEmpty,
                 .phoneFormatIsWrong:    await displayUpdatedDeliveryInfo(phoneError: error.localizedDescription)
            
            case .addressValueIsEmpty,
                 .addressFormatIsWrong:  await displayUpdatedDeliveryInfo(addressError: error.localizedDescription)
            
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
