//
//  UITraitCollection.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/13.
//

import UIKit

extension UITraitCollection {
    func separateValue<T>(dark: T, light: T) -> T {
        let value = userInterfaceStyle == .dark ? dark : light
        return value
    }
}
