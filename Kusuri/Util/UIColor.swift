//
//  UIColor.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/08/14.
//

import UIKit

extension UIColor {
    
    static let primaryDark     = from(hex: "FF5A00")
    static let primary         = from(hex: "4267B3")
    static let primaryPale     = from(hex: "C0CCE7")
    
    static let secondaryDark   = from(hex: "419BA4")
    static let secondary       = from(hex: "0CB2B4")
    static let secondaryPale   = from(hex: "80CFD4")
    
    static let strongestGray   = from(hex: "444444")
    static let strongGray      = from(hex: "888888")
    static let gray            = from(hex: "AAAAAA")
    static let weakGray        = from(hex: "CCCCCC")
    static let weakestGray     = from(hex: "DDDDDD")
    
    static let backgroundBase  = from(hex: "F9F9F9")
    static let backgroundCover = from(hex: "F2F2F2")
    static let border          = #colorLiteral(red: 0.8666666667, green: 0.8666666667, blue: 0.8666666667, alpha: 1)
    static let background      = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
    
    static let header          = backgroundCover
    
    static let strongText      = from(hex: "333333")
    static let text            = strongestGray
    static let weakText        = strongGray
    
    static let medical         = from(hex: "EEE8AA")
    static let otc             = from(hex: "FFBCBC")

    static func from(hex: String, alpha: Double = 1.0) -> UIColor {
        var color: UInt64 = 0
        
        guard Scanner(string: hex).scanHexInt64(&color) else { return .white }
        
        let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(color & 0x0000FF) / 255.0

        return .init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
}
