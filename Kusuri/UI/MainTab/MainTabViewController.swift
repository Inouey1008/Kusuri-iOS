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
        view.backgroundColor = .white
        tabBar.layer.shadowColor = UIColor.lightGray.cgColor
        tabBar.layer.shadowOpacity = 0.5
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 5
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.layer.borderWidth = 0
        tabBar.clipsToBounds = false
        tabBar.tintColor = .primary
        
        setViewControllers([
//            あとで直す！！
//            SearchPagerTabRouter.generate(),
//            BarcodeReadRouter.generate(),
//            MenuRouter.generate()
            UIViewController(),
            UIViewController(),
            UIViewController(),
        ], animated: false)
    }
}
