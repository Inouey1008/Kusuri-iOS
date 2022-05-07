//
//  NSObject.swift
//  NSObject
//
//  Created by Yus Inoue on 2021/09/18.
//

import Foundation

protocol ApplyProtocol {}

extension ApplyProtocol {
    func apply(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
    
    static var className: String {
        return String(describing: type(of: self))
    }
}

extension NSObject: ApplyProtocol {}
