//
//  CheckoutPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 07.03.2023.
//

import Foundation

@MainActor
protocol CheckoutRouter {
    func presentThankYouForOrder()
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
    private let orderUseCase: OrderUseCase
    private let profileUseCase: ProfileUseCase
    
    private let cartItems: [CartItem]
    private var shippingMethod: ShippingMethod!
    private var deliveryInfo: DeliveryInfo!
    
    init(view: CheckoutView?,
         router: CheckoutRouter,
         orderUseCase: OrderUseCase,
         profileUseCase: ProfileUseCase,
         cartItems: [CartItem]
    ) {
        self.view = view
        self.router = router
        self.orderUseCase = orderUseCase
        self.profileUseCase = profileUseCase
        self.cartItems = cartItems
    }
}

extension CheckoutPresenterImpl: CheckoutPresenter {
    
    func viewDidLoad() async {
        await view?.display(title: "CHECKOUT")
        await displayCartItems()
        await displayOrderDetails()
        await displayDeliveryInfo()
    }
}

// MARK: - Private extension

private extension CheckoutPresenterImpl {
    
    func displayCartItems() async {
        let viewModels = cartItems.map(createOrderItemModel)
        let items = viewModels.map(OrderSectionItem.init)
        let section = OrderItemsSection(items: items)
        await view?.display(itemsSection: section)
    }
    
    func displayOrderDetails() async {
        await with(errorHandler) {
            let shippingRequest = ShippingMethodsRequest(user: Session.shared.user)
            let shippingMethods = try await orderUseCase.execute(shippingRequest)
            if shippingMethod == nil { shippingMethod = shippingMethods.first }
            let shippingMethodModels = shippingMethods.map(createShippingMethodModel)
            
            let summaryRequest = OrderSummaryRequest(user: Session.shared.user, cartItems: cartItems, shippingMethod: shippingMethod)
            let orderSummary = try await orderUseCase.execute(summaryRequest)
            let orderDetails = createOrderDetailsModel(with: orderSummary, shippingMethods: shippingMethodModels)
            
            await view?.display(orderDetails: orderDetails)
        }
    }
    
    func displayDeliveryInfo() async {
        await with(errorHandler) {
            let profileRequest = GetProfileRequest(user: Session.shared.user)
            let profile = try await profileUseCase.execute(profileRequest)
            deliveryInfo = DeliveryInfo(
                firstName: profile.firstName ?? "",
                lastName: profile.lastName ?? "",
                emailAddress: profile.email,
                phoneNumber: profile.phone ?? "",
                shippingAddress: profile.address ?? ""
            )
            let deliveryInfoModel = createDeliveryInfoModel(with: deliveryInfo)
            await view?.display(deliveryInfo: deliveryInfoModel)
        }
    }
    
    func displayUpdatedDeliveryInfo(
        firstNameError: String? = nil,
        lastNameError: String? = nil,
        emailError: String? = nil,
        phoneError: String? = nil,
        addressError: String? = nil
    ) async {
        var infoModel = createDeliveryInfoModel(with: deliveryInfo)
        infoModel.firstNameError = firstNameError
        infoModel.lastNameError = lastNameError
        infoModel.emailError = emailError
        infoModel.phoneError = phoneError
        infoModel.addressError = addressError
        
        await view?.display(deliveryInfo: infoModel)
    }
    
    // MARK: Creational methods
    
    func createOrderItemModel(with cartItem: CartItem) -> OrderItemModel? {
        guard let variation = cartItem.product.variations.first else { return nil }
        return OrderItemModel(
            productID: variation.productID,
            name: cartItem.product.name.uppercased(),
            color: "\(variation.frameColor)/\(variation.lenseColor)",
            price: "$ " + String(format: "%.2f", Double(variation.price) / 100.0),
            quantity: "qty: \(cartItem.amount)",
            imageData: variation.imageData?.first ?? Data()
        )
    }
    
    func createShippingMethodModel(with shippingMethod: ShippingMethod) -> ShippingMethodModel {
        .init(
            name: shippingMethod.name,
            duration: shippingMethod.duration,
            price: shippingMethod.price == 0 ? "FREE" : "$ " + String(format: "%.2f", Double(shippingMethod.price) / 100.0),
            isSelected: self.shippingMethod == shippingMethod,
            didSelectMethod: { [weak self] in
                await self?.didSelectShippingMethod(shippingMethod)
            }
        )
    }
    
    func createOrderDetailsModel(with orderSummary: OrderSummary, shippingMethods: [ShippingMethodModel]) -> OrderDetailsModel {
        .init(
            shippingMethods: shippingMethods,
            subtotal: "$ " + String(format: "%.2f", Double(orderSummary.subtotal) / 100.0),
            shippingCost: "$ " + String(format: "%.2f", Double(orderSummary.shipping) / 100.0),
            total: "$ " + String(format: "%.2f", Double(orderSummary.total) / 100.0)
        )
    }
    
    func createDeliveryInfoModel(with deliveryInfo: DeliveryInfo) -> DeliveryInfoModel {
        .init(
            firstName: deliveryInfo.firstName,
            lastName: deliveryInfo.lastName,
            emailAddress: deliveryInfo.emailAddress,
            phoneNumber: deliveryInfo.phoneNumber,
            shippingAddress: deliveryInfo.shippingAddress,
            paymentButtonTapped: { [weak self] viewModel in
                await self?.paymentButtonTapped(viewModel: viewModel)
            }
        )
    }
    
    // MARK: User actions
    
    func didSelectShippingMethod(_ shippingMethod: ShippingMethod) async {
        self.shippingMethod = shippingMethod
        await displayOrderDetails()
    }
    
    func paymentButtonTapped(viewModel: DeliveryInfoViewModel) async {
        await with(errorHandler) {
            // update fields
            deliveryInfo.firstName = viewModel.firstName
            deliveryInfo.lastName = viewModel.lastName
            deliveryInfo.emailAddress = viewModel.emailAddress
            deliveryInfo.phoneNumber = viewModel.phoneNumber
            deliveryInfo.shippingAddress = viewModel.shippingAddress
            
            // send request
            let request = CreateOrderRequest(user: Session.shared.user, cartItems: cartItems, shippingMethod: shippingMethod, deliveryInfo: deliveryInfo)
            try await orderUseCase.execute(request)
            await router.presentThankYouForOrder()
        }
    }
    
    func errorHandler(_ error: Error) async {
        if let error = error as? AppError {
            switch error {
            case .networkError,
                 .userProfileNotFound:   await view?.displayError(title: "Error", message: error.localizedDescription)

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
