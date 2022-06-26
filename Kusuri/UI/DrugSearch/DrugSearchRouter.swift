//
//  DrugSearchRouter.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/06.
//

import UIKit.UIViewController
import StoreKit

final class DrugSearchRouter {
    private unowned let view: UIViewController

    init(view: UIViewController) {
        self.view = view
    }

    static func generate(type: SearchType) -> UIViewController {
        let viewModel = DrugSearchViewModel()
        let view = DrugSearchViewController()
        let router = DrugSearchRouter(view: view)
        view.viewModel = viewModel
        view.searchType = type
        viewModel.router = router
        viewModel.searchType = type
        return view
    }
    
    func showWebView(title: String , url: String) {
        guard let url = URL(string: url) else {
            return
        }
        let webView = ModalPresentationWebView(title: title, url: url)
        webView.delegate = self
        webView.modalPresentationStyle = .fullScreen
        view.present(webView, animated: true, completion: nil)
    }
}

extension DrugSearchRouter: ModalPresentationWebViewDelegate {
    func dissmiss() {
        Configuration.drugInfoImpressions += 1
        
        if Configuration.drugInfoImpressions % 5 == 0 && Configuration.reviewPopupDidShown == false {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                Configuration.reviewPopupDidShown = true
            }
        }
    }
}
