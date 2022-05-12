//
//  WebView.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/03/01.
//

import UIKit
import WebKit
import SnapKit

class DrugInfoDetailViewController: UIViewController, WKUIDelegate {
    var viewModel: DrugInfoDetailViewModel!
    private let viewArea = UIView()
    private var webView: WKWebView!
    private var url: URL?
    
    private let headerView: PageSheetStyleHeaderView = {
       let view = PageSheetStyleHeaderView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: url!)
        webView?.load(request)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.backgroundColor = .backgroundCover
        viewArea.addSubview(webView)
        viewArea.addSubview(headerView)
        adjustLayout()
        view = viewArea
        view.backgroundColor = .backgroundCover
    }
    
    init(url: String, title: String) {
        super.init(nibName: nil, bundle: nil)
        self.url = URL(string: url)
        headerView.setTitle(title)
        headerView.addAction { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func adjustLayout() {
        webView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        headerView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
        }
    }
}
