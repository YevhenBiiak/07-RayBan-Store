//
//  DeliveryInfoModel.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 09.03.2023.
//

struct DeliveryInfoModel: DeliveryInfoViewModel {
    var firstName: String
    var lastName: String
    var emailAddress: String
    var phoneNumber: String
    var shippingAddress: String
    var firstNameError: String?
    var lastNameError: String?
    var emailError: String?
    var phoneError: String?
    var addressError: String?
    let paymentButtonTapped: (DeliveryInfoViewModel) async -> Void
}
