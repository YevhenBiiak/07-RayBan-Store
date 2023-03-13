//
//  OrderRequests.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.03.2023.
//

struct OrdersRequest {
    let user: User
}

struct DeleteOrderRequest {
    let user: User
    let orderID: OrderID
}

struct OrderSummaryRequest {
    let user: User
    let cartItems: [CartItem]
    let shippingMethod: ShippingMethod
}

struct CreateOrderRequest {
    let user: User
    let cartItems: [CartItem]
    let shippingMethod: ShippingMethod
    let deliveryInfo: DeliveryInfo
}

struct ShippingMethodsRequest {
    let user: User
}
