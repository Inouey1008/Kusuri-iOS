//
//  String.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/08/15.
//

import Foundation

extension String {
    func utf8Encoding() -> String {
        let allowedCharacters = NSCharacterSet.alphanumerics.union(.init(charactersIn: "-._~"))
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)!
    }
}
