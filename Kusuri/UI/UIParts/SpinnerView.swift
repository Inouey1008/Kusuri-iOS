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

final class SpinnerView: UIView {
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var animating: Bool = false {
        didSet {
            if animating {
                startAnimating()
            } else {
                stopAnimating()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        isHidden = true
        addSubview(indicator)
        adjustLayout()
    }
    
    private func adjustLayout() {
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
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
