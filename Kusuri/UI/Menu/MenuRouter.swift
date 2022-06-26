//
//  MenuRouter.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/06.
//

import UIKit.UIViewController

final class MenuRouter {
    private unowned let view: UIViewController

    init(view: UIViewController) {
        self.view = view
    }

    static func generate() -> UIViewController {
        let viewModel = MenuViewModel()
        let view = MenuViewController()
        let router = MenuRouter(view: view)
        viewModel.router = router
        view.viewModel = viewModel
        view.tabBarItem = UITabBarItem(title: "メニュー", image: UIImage(systemName: "line.3.horizontal"), tag: 0)
        view.tabBarItem.setTitleTextAttributes([.font : UIFont.tabBarTitle, .foregroundColor : UIColor.primary], for: .normal)
        view.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        return UINavigationController(rootViewController: view)
    }
    
    func showWebView(title: String , url: String) {
        guard let url = URL(string: url) else {
            return
        }
        let webView = ModalPresentationWebView(title: title, url: url)
        webView.modalPresentationStyle = .fullScreen
        view.present(webView, animated: true, completion: nil)
    }
    
    func openBrowser(_ url: String) {
        let _url = NSURL(string: url)
        if UIApplication.shared.canOpenURL(_url! as URL) {
            UIApplication.shared.open(_url! as URL, options: [:], completionHandler: nil)
        }
    }
}
