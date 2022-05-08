//
//  UIFont.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/10/03.
//

import UIKit

extension UIFont {
    static let largeSize: CGFloat = UIDevice.current.separateValue(forPad: 30, forPhone: 20)
    static let mediumSize: CGFloat = UIDevice.current.separateValue(forPad: 25, forPhone: 16)
    static let smallSize: CGFloat = UIDevice.current.separateValue(forPad: 20, forPhone: 12)
    
    static var largeBold: UIFont {
        return BoldFont(size: largeSize)
    }
    
    static var mediumBold: UIFont {
        return BoldFont(size: mediumSize)
    }
    
    static var smallBold: UIFont {
        return BoldFont(size: smallSize)
    }
    
    static var largeRegular: UIFont {
        return RegularFont(size: largeSize)
    }
    
    static var mediumRegular: UIFont {
        return RegularFont(size: mediumSize)
    }
    
    static var smallRegular: UIFont {
        return RegularFont(size: smallSize)
    }
    
    static var largeLight: UIFont {
        return LightFont(size: largeSize)
    }
    
    static var mediumLight: UIFont {
        return LightFont(size: mediumSize)
    }
    
    static var smallLight: UIFont {
        return LightFont(size: smallSize)
    }
    
    static var tabBarTitle: UIFont {
        return UIFont(name: "NotoSansJP-Regular", size: UIDevice.current.separateValue(forPad: 14.0, forPhone: 10.5))!
    }
    
    static func BoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansJP-Bold", size: size)!
    }
    
    static func RegularFont(size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansJP-Regular", size: size)!
    }
    
    static func LightFont(size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansJP-Light", size: size)!
    }
}
