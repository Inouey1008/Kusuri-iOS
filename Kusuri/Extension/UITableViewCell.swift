//
//  UITableViewCell.swift
//  UITableViewCell
//
//  Created by Yus Inoue on 2021/09/18.
//

import UIKit

extension UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
