//
//  OrdersPresenter.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 11.03.2023.
//

import Foundation

@MainActor
protocol OrdersRouter {
    func presentOrders()
}

@MainActor
protocol OrdersView: AnyObject {
    func display(title: String)
    func display(viewModels: [ViewModel])
    func displayError(title: String, message: String?)
}

protocol OrdersPresenter {
    func viewDidLoad() async
}

class OrdersPresenterImpl {
    
    private weak var view: OrdersView?
    private let router: OrdersRouter
    private let orderUseCase: OrderUseCase
    
    init(view: OrdersView?, router: OrdersRouter, orderUseCase: OrderUseCase) {
        self.view = view
        self.router = router
        self.orderUseCase = orderUseCase
    }
}

extension OrdersPresenterImpl: OrdersPresenter {
    
    func viewDidLoad() async {
        await with(errorHandler) {
            await view?.display(title: "ORDER HISTORY")
            let request = OrdersRequest(user: Session.shared.user)
            let orders = try await orderUseCase.execute(request)
            let models = orders.map(createOrderModel)
            await view?.display(viewModels: models)
        }
    }
}

// MARK: - Private extension

private extension OrdersPresenterImpl {
    
    func createOrderModel(with order: Order) -> OrderModel {
        OrderModel(
            date: order.date.formatted(date: .abbreviated, time: .shortened),
            items: order.items.compactMap(createOrderItemModel),
            total: "TOTAL: $ " + String(format: "%.2f", Double(order.summary.total) / 100.0),
            deleteOrderButtonTapped: { [weak self] in
                await self?.deleteButtonTapped(order.orderID)
            },
            addToCartButtonTapped: { [weak self] in
                await self?.addToCartButtonTapped(order)
            }
        )
    }
    
    func createOrderItemModel(with orderItem: OrderItem) -> OrderItemModel? {
        guard let variation = orderItem.product.variations.first else { return nil }
        return OrderItemModel(
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
            let models = orders.map(createOrderModel)
            await view?.display(viewModels: models)
        }
    }
    
    func addToCartButtonTapped(_ order: Order) async {
        await with(errorHandler) {
            
        }
    }
    
    func errorHandler(_ error: Error) async {
        await view?.displayError(title: "Error", message: error.localizedDescription)
    }
}
