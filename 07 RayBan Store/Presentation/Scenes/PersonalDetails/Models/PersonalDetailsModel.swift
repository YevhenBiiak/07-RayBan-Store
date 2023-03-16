//
//  PersonalDetailsModel.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 14.03.2023.
//

struct PersonalDetailsModel: PersonalDetailsViewModel {
    var firstName: String
    var lastName: String
    var phoneNumber: String
    var shippingAddress: String
    let emailAddress: String
    let password: String
    var firstNameError: String?
    var lastNameError: String?
    var phoneError: String?
    var addressError: String?
}
