//
//  UIColor.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/08/14.
//

import UIKit

extension UIColor {
    static let primaryDark     = UIColor(named: "PrimaryDark")!
    static let primary         = UIColor(named: "Primary")!
    static let primaryPale     = UIColor(named: "PrimaryPale")!
    static let secondaryDark   = UIColor(named: "SecondaryDark")!
    static let secondary       = UIColor(named: "Secondary")!
    static let secondaryPale   = UIColor(named: "SecondaryPale")!
    static let strongestGray   = UIColor(named: "StrongestGray")!
    static let strongGray      = UIColor(named: "StrongGray")!
    static let gray            = UIColor(named: "Gray")!
    static let weakGray        = UIColor(named: "WeakGray")!
    static let weakestGray     = UIColor(named: "WeakestGray")!
    static let backgroundBase  = UIColor(named: "BackgroundBase")!
    static let backgroundCover = UIColor(named: "BackgroundCover")!
    static let header          = UIColor(named: "BackgroundCover")!
    static let strongText      = UIColor(named: "StrongText")!
    static let text            = UIColor(named: "Text")!
    static let weakText        = UIColor(named: "WeakText")!
    static let medical         = UIColor(named: "Medical")!
    static let otc             = UIColor(named: "Otc")!

    static func from(hex: String, alpha: Double = 1.0) -> UIColor {
        var color: UInt64 = 0
        guard Scanner(string: hex).scanHexInt64(&color) else {
            return .white
        }
        let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(color & 0x0000FF) / 255.0
        return .init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
}
