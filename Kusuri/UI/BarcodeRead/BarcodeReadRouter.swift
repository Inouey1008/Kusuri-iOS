//
//  BarcodeRouter.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/05.
//

import UIKit.UIViewController

final class BarcodeReadRouter {
    private unowned let view: UIViewController

    init(view: UIViewController) {
        self.view = view
    }

    static func generate() -> UIViewController {
        let viewModel = BarcodeReadViewModel()
        let view = BarcodeReadViewController()
        let router = BarcodeReadRouter(view: view)
        viewModel.router = router
        view.viewModel = viewModel
        view.tabBarItem = UITabBarItem(title: "バーコード", image: UIImage(systemName: "barcode"), tag: 0)
        view.tabBarItem.setTitleTextAttributes([.font : UIFont.tabBarTitle, .foregroundColor : UIColor.primary], for: .normal)
        view.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        return UINavigationController(rootViewController: view)
    }
}
