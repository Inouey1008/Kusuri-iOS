//
//  SpinnerView.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/10/01.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class IndicatorView: UIView {
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var animating: Bool = false {
        didSet {
            animating ? startAnimating() : stopAnimating()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isHidden = true
        addSubview(indicator)
        adjustLayout()
    }
    
    private func adjustLayout() {
        indicator.snp.makeConstraints({ make in
            make.center.equalToSuperview()
        })
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func startAnimating() {
        indicator.startAnimating()
        isHidden = false
    }

    private func stopAnimating() {
        indicator.stopAnimating()
        isHidden = true
    }
}
