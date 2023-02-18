//
//  CategoryVM.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.10.2022.
//

import UIKit

//struct CategoryVM {
//    let name: String
//    var image: UIImage?
//}
//
//extension CategoryVM: Hashable {
//    static let emptyCategory = CategoryVM(name: UUID().uuidString)
//
//    static let defaultCategories = [
//        CategoryVM(name: "MEN"),
//        CategoryVM(name: "WOMEN"),
//        CategoryVM(name: "KIDS")
//    ]
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(name)
//    }
//}
//
//extension Array where Element == ProductDTO {
//    var asCategoriesVM: [CategoryVM] {
//        self.map { item in
//            CategoryVM(
//                name: item.family,
//                image: UIImage(data: item.images?.first ?? Data()))
//        }
//    }
//}
