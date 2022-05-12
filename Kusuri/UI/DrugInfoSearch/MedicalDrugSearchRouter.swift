//
//  MedicalDrugSearchRouter.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/06.
//

import UIKit.UIViewController

final class MedicalDrugSearchRouter {
    private unowned let view: UIViewController

    init(view: UIViewController) {
        self.view = view
    }

    static func generate() -> UIViewController {
        let viewModel = MedicalDrugSearchViewModel()
        let view = MedicalDrugSearchViewController()
        let router = MedicalDrugSearchRouter(view: view)
        view.viewModel = viewModel
        viewModel.router = router
        return view
    }
}
