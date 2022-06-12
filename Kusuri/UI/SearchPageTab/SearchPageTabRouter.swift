//
//  SearchPageTabViewRouter.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/05.
//

import UIKit.UIViewController

final class SearchPageTabRouter {
    private unowned let view: UIViewController

    init(view: UIViewController) {
        self.view = view
    }

    static func generate() -> UIViewController {
        let viewModel = SearchPageTabViewModel()
        let view = SearchPageTabViewController()
        let router = SearchPageTabRouter(view: view)
        viewModel.router = router
        view.viewModel = viewModel
        view.tabBarItem = UITabBarItem(title: "検索", image: UIImage(systemName: "magnifyingglass"), tag: 0)
        view.tabBarItem.setTitleTextAttributes([.font : UIFont.tabBarTitle, .foregroundColor : UIColor.primary], for: .normal)
        view.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        return UINavigationController(rootViewController: view)
    }
}
