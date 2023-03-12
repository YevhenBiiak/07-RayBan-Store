//
//  ViewModelRepresentable.swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 11.03.2023.
//

protocol ViewModel {}

protocol ViewModelRepresentable {
    var viewModel: ViewModel? { get set }
}
