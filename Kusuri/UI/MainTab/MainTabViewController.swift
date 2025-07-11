//
//  MainTabViewController.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/08/14.
//

import UIKit

final class MainTabViewController: UITabBarController {
    var viewModel: MainTabViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundBase
        tabBar.layer.shadowColor = UITraitCollection.current.separateValue(dark: UIColor.clear.cgColor, light: UIColor.lightGray.cgColor)
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 5
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.layer.borderWidth = 0
        tabBar.clipsToBounds = false
        tabBar.tintColor = .primary
        setViewControllers([SearchPageTabRouter.generate(), BarcodeReadRouter.generate(), MenuRouter.generate()], animated: false)
    }
}
