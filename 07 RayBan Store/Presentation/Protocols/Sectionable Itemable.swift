//
//  Sectionable Itemable.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 10.02.2023.
//

import Foundation

protocol Sectionable {
    var header: String { get }
    var items: [IndexPath: any Itemable] { get set }
}

protocol Itemable {
    associatedtype ViewModel
    var viewModel: ViewModel? { get }
}
