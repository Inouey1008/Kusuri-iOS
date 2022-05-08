//
//  MenuSectionModel.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/07.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

typealias MenuSectionModel = SectionModel<MenuSection, MenuItem>

enum MenuSection: Int {
    case support
    case app
    
    var title: String {
        switch self {
        case .support:
            return "サポート"
        case .app:
            return "アプリについて"
        }
    }
}

enum MenuItem: Int {
    case contactUs
    case appReview
    case useTerms
    case plivacyPolicy
    case version
    
    var title: String {
        switch self {
        case .contactUs:
            return "お問い合わせ"
        case .appReview:
            return "レビューを書く"
        case .useTerms:
            return "利用規約"
        case .plivacyPolicy:
            return "プライバシーポリシー"
        case .version:
            return "バージョン"
        }
    }
    
    var description: String? {
        switch self {
        case .contactUs, .appReview, .useTerms, .plivacyPolicy:
            return nil
        case .version:
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        }
    }
    
    var accessoryView: UIView? {
        switch self {
        case .contactUs, .appReview:
            let imageView = UIImageView(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"))
            imageView.tintColor = .gray
            return imageView
        case .useTerms, .plivacyPolicy:
            let imageView = UIImageView(image: UIImage(systemName: "chevron.forward"))
            imageView.tintColor = .gray
            return imageView
        case .version:
            return nil
        }
    }
    
    var selectionStyle: UITableViewCell.SelectionStyle {
        switch self {
        case .contactUs, .appReview, .useTerms, .plivacyPolicy:
            return .gray
        case .version:
            return .none
        }
    }
}
