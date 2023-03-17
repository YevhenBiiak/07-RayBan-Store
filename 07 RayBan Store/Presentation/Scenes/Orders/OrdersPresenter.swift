//
//  OrdersPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 11.03.2023.
//

import Foundation

@MainActor
protocol OrdersRouter {
    func presentShoppingCart()
}

@MainActor
protocol OrdersView: AnyObject {
    func display(title: String)
    func display(viewModels: [ViewModel])
    func displayError(title: String, message: String?)
}

protocol OrdersPresenter {
    func viewDidLoad() async
    func viewWillAppear() async
}

class OrdersPresenterImpl {
    
    private weak var view: OrdersView?
    private let router: OrdersRouter
    private let cartUseCase: CartUseCase
    private let orderUseCase: OrderUseCase
    
    init(view: OrdersView? = nil, router: OrdersRouter, cartUseCase: CartUseCase, orderUseCase: OrderUseCase) {
        self.view = view
        self.router = router
        self.cartUseCase = cartUseCase
        self.orderUseCase = orderUseCase
    }
}

extension OrdersPresenterImpl: OrdersPresenter {
    
    func viewDidLoad() async {
        await displayOrders()
    }
    
    func viewWillAppear() async {
        await displayOrders()
    }
}

// MARK: - Private extension

private extension OrdersPresenterImpl {
    
    func displayOrders() async {
        await with(errorHandler) {
            await view?.display(title: "ORDER HISTORY")
            let request = OrdersRequest(user: Session.shared.user)
            let orders = try await orderUseCase.execute(request)
            let models = try await orders.concurrentMap(createOrderModel)
            await view?.display(viewModels: models)
        }
    }
    
    func createOrderModel(with order: Order) async throws -> OrderModel {
        var isItemsInCart = false
        
        try await order.items.compactMap{ $0.product.variations.first }.concurrentForEach { [weak self] variation in
            let inCartRequest = IsProductInCartRequset(user: Session.shared.user, productID: variation.productID)
            isItemsInCart = try await self?.cartUseCase.execute(inCartRequest) ?? false
        }
        
        return .init(
            date: order.date.formatted(date: .abbreviated, time: .shortened),
            items: order.items.compactMap(createOrderItemModel),
            isItemsInCart: isItemsInCart,
            total: "TOTAL: $ " + String(format: "%.2f", Double(order.summary.total) / 100.0),
            deleteOrderButtonTapped: { [weak self] in
                await self?.deleteButtonTapped(order.orderID)
            }, addToCartButtonTapped: { [weak self] in
                await self?.addToCartButtonTapped(order)
            }, showCartButtonTapped: { [weak self] in
                await self?.router.presentShoppingCart()
            }
        )
    }
    
    func createOrderItemModel(with orderItem: OrderItem) -> OrderItemModel? {
        guard let variation = orderItem.product.variations.first else { return nil }
        
        return .init(
            productID: variation.productID,
            name: orderItem.product.name.uppercased(),
            color: "\(variation.frameColor)/\(variation.lenseColor)",
            price: "$ " + String(format: "%.2f", Double(variation.price) / 100.0),
            quantity: "qty: \(orderItem.amount)",
            imageData: variation.imageData?.first ?? Data()
        )
    }
    
    func deleteButtonTapped(_ orderID: String) async {
        await with(errorHandler) {
            let request = DeleteOrderRequest(user: Session.shared.user, orderID: orderID)
            let orders = try await orderUseCase.execute(request)
            let models = try await orders.concurrentMap(createOrderModel)
            await view?.display(viewModels: models)
        }
    }
    
    func addToCartButtonTapped(_ order: Order) async {
        await with(errorHandler) {
            try await order.items.asyncForEach { item in
                let addRequest = AddCartItemRequest(user: Session.shared.user, product: item.product, amount: 1)
                try await cartUseCase.execute(addRequest)
            }
            await displayOrders()
        }
    }
    
    func errorHandler(_ error: Error) async {
        await view?.displayError(title: "Error", message: error.localizedDescription)
    }
}
