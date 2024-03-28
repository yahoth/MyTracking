//
//  UIFont + SF Compact.swift
//  MyTracking
//
//  Created by TAEHYOUNG KIM on 3/2/24.
//

import UIKit

extension UIFont {
    static func roundedFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let roundedDescripter = UIFont.systemFont(ofSize: size, weight: weight).fontDescriptor.withDesign(.rounded)!
        let font = UIFont(descriptor: roundedDescripter, size: size)
        return font
    }
}


