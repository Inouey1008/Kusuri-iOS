//
//  WebView.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/03/01.
//

import UIKit
import WebKit
import SnapKit
import RxSwift

protocol ModalPresentationWebViewDelegate {
    func dissmiss()
}

final class ModalPresentationWebView: UIViewController, WKUIDelegate, WKNavigationDelegate {
    private let url: URL
    private var webView: WKWebView!
    
    var delegate: ModalPresentationWebViewDelegate?
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundBase
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .strongText
        label.font = .largeRegular
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark.circle.fill")
        button.setImage(image, for: .normal)
        button.imageView?.tintColor = .gray
        button.imageView?.contentMode = .scaleAspectFill
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.addAction(for: .touchUpInside, { [weak self] in
            guard let self = self else { return }
            
            self.dismiss(animated: true, completion: {
                self.delegate?.dissmiss()
            })
        })
        return button
    }()
    
    private let indicatorView = IndicatorView()
    
    private let noNetworkView: EmptyStateView = {
        let view = EmptyStateView()
        view.imageView.image = UIImage(systemName: "wifi.slash")
        view.imageView.tintColor = .weakText
        view.titleLabel.text = "インターネット接続がありません"
        view.messageLabel.text = "良好な通信環境でもう一度お試しください"
        view.isHidden = true
        return view
    }()
    
    private var timer: Timer?
    
    init(title: String, url: URL) {
        self.titleLabel.text = title
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundBase
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.backgroundColor = .backgroundCover
        webView.load(URLRequest(url: url))
        headerView.addSubview(titleLabel)
        headerView.addSubview(closeButton)
        view.addSubview(headerView)
        view.addSubview(webView)
        view.addSubview(indicatorView)
        view.addSubview(noNetworkView)
        adjustLayout()
    }
    
    private func adjustLayout() {
        titleLabel.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
        closeButton.snp.makeConstraints({ make in
            let rightInset = UIDevice.current.separateValue(forPad: 24, forPhone: 16)
            let heightWidth = UIDevice.current.separateValue(forPad: 40, forPhone: 30)
            
            make.right.equalToSuperview().inset(rightInset)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(heightWidth)
        })
        headerView.snp.makeConstraints({ make in
            let height = UIDevice.current.separateValue(forPad: 66, forPhone: 52)
            
            make.left.top.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(height)
        })
        webView.snp.makeConstraints({ make in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.bottom.equalTo(view.safeAreaInsets)
        })
        indicatorView.snp.makeConstraints({ make in
            make.edges.equalTo(webView)
        })
        noNetworkView.snp.makeConstraints({ make in
            make.edges.equalTo(webView)
        })
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorView.animating = false
        timer?.invalidate()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicatorView.animating = false
        timer?.invalidate()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicatorView.animating = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 8, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.noNetworkView.isHidden = false
            self.indicatorView.animating = false
        }
    }
}
