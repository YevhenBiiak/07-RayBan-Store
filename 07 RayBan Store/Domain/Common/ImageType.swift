//
//  ImageType.swift
//  07 RayBan Store
//
//  Created by Евгений Бияк on 12.10.2022.
//

struct ImageType: OptionSet {
    let rawValue: Int

    static let  main        = ImageType(rawValue: 1 << 0)
    static let  main2       = ImageType(rawValue: 1 << 1)
    static let  back        = ImageType(rawValue: 1 << 2)
    static let  front       = ImageType(rawValue: 1 << 3)
    static let  `left`      = ImageType(rawValue: 1 << 4)
    static let  front2      = ImageType(rawValue: 1 << 5)
    static let  perspective = ImageType(rawValue: 1 << 6)
}
