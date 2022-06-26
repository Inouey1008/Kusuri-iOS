//
//  BarcodeRouter.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/05.
//

import UIKit.UIViewController
import StoreKit

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
    
    func showWebView(title: String , url: String) {
        guard let url = URL(string: url) else {
            return
        }
        let webView = ModalPresentationWebView(title: title, url: url)
        webView.delegate = self
        webView.modalPresentationStyle = .fullScreen
        view.present(webView, animated: true, completion: nil)
    }
    
    func showSetting() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString ) else {
            return
        }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
}

extension BarcodeReadRouter: ModalPresentationWebViewDelegate {
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
