//
//  WebView.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/07.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    private var webView: WKWebView!
    private var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = URLRequest(url: url!)
        webView?.load(request)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    init(url: String) {
        super.init(nibName: nil, bundle: nil)
        self.url = URL(string: url)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
