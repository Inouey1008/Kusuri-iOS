//
//  Configuration.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/06/26.
//

import Foundation

final class Configuration {
    
    static func setup() {
        UserDefaults.standard.register(
            defaults: [
                "DrugInfoImpressions": 0,
                "ReviewPopupDidShown": false,
                "FirstLaunch": false,
            ]
        )
    }
    
    static var drugInfoImpressions: Int {
        get {
            return UserDefaults.standard.integer(forKey: "DrugInfoImpressions")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "DrugInfoImpressions")
        }
    }
    
    static var reviewPopupDidShown: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "ReviewPopupDidShown")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "ReviewPopupDidShown")
        }
    }
    
    static var firstLaunch: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "FirstLaunch")
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "FirstLaunch")
        }
    }
    
}

