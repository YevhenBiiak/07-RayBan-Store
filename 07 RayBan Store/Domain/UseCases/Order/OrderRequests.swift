//
//  OrderRequests.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 03.03.2023.
//

struct OrdersRequest {
    let user: User
}

struct OrderItemsRequest {
    let user: User
    let orderID: String
}

struct ShippingMethodsRequest {
    let user: User
}

struct OrderSummaryRequest {
    let user: User
    let shippingMethods: ShippingMethod
}

struct CreateOrderRequest {
    let user: User
    let shippingAddress: String
    let shippingMethods: String
}
