//
//  MainTabRouter.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/05.
//

import UIKit.UIViewController

final class MainTabRouter {
    private unowned let view: UIViewController

    init(view: UIViewController) {
        self.view = view
    }

    static func generate() -> UIViewController {
        let viewModel = MainTabViewModel()
        let view = MainTabViewController()
        let router = MainTabRouter(view: view)
        viewModel.router = router
        view.viewModel = viewModel
        return view
    }
}
