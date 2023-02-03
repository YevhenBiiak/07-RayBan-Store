//
//  String + .swift
//  07 RayBan Store
//
//  Created by Yevhen Biiak on 01.02.2023.
//

import UIKit

extension String {
    
    var underlined: NSMutableAttributedString {
        let string = NSMutableAttributedString(string: self)
        string.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: self.count)
        )
        return string
    }
}
