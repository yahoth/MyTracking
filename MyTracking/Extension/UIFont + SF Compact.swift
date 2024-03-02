//
//  UIFont + SF Compact.swift
//  MyTracking
//
//  Created by TAEHYOUNG KIM on 3/2/24.
//

import UIKit

extension UIFont {
    static func sfCompact(size: CGFloat, weight: SFCompactRoundedWeight) -> UIFont? {
        return UIFont(name: weight.rawValue, size: size)
    }

    enum SFCompactRoundedWeight: String {
        case black = "SFCompactRounded-Black"
        case bold = "SFCompactRounded-Bold"
        case regular = "SFCompactRounded-Regular"
        case medium = "SFCompactRounded-Medium"
    }
}


