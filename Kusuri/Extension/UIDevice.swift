//
//  UIDevice.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/10/01.
//

import UIKit

extension UIDevice {
    func separateValue<T>(forPad: T, forPhone: T) -> T {
        let value = userInterfaceIdiom == .pad ? forPad : forPhone
        return value
    }
}
