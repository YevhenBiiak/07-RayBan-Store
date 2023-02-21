//
//  CategoryVM.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 04.10.2022.
//

import UIKit

struct CategorySection: Sectionable {
    var header: String?
    var items: [any Itemable]
}

struct CategoryItem: Itemable {
    var viewModel: CategoryCellViewModel?
}

struct CategoryCellViewModel {
    let name: String
    var imageData: Data?
}

//---------------------------------------------

struct CategoryVM {
    let name: String
    var image: UIImage?
}

extension CategoryVM: Hashable {
    static let emptyCategory = CategoryVM(name: UUID().uuidString)

    static let defaultCategories = [
        CategoryVM(name: "MEN"),
        CategoryVM(name: "WOMEN"),
        CategoryVM(name: "KIDS")
    ]

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension Array where Element == Product {
    var asCategoriesVM: [CategoryVM] {
        self.map { item in
            CategoryVM(
                name: item.style.rawValue.uppercased(),
                image: UIImage(data: item.variations.first?.imageData?.first ?? Data()))
        }
    }
}
