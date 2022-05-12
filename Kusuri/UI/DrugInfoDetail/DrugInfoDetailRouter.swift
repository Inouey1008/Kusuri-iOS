//
//  DrugInfoDetailRouter.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/05.
//

import UIKit.UIViewController

final class DrugInfoDetailRouter {
    private unowned let view: UIViewController

    init(view: UIViewController) {
        self.view = view
    }

    static func generate(url: String, title: String) -> UIViewController {
        let viewModel = DrugInfoDetailViewModel()
        let view = DrugInfoDetailViewController(url: url, title: title)
        let router = DrugInfoDetailRouter(view: view)
        viewModel.router = router
        view.viewModel = viewModel
        return view
    }
}
