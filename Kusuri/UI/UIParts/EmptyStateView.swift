//
//  EmptyStateView.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/10/02.
//

import UIKit
import SnapKit

final class EmptyStateView: UIView {
    
    lazy var imageView = UIImageView()
    
    lazy var titleLabel = UILabel().apply {
        $0.textColor = .gray
        $0.font = .largeRegular
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    lazy var messageLabel = UILabel().apply {
        $0.textColor = .gray
        $0.font = .mediumLight
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundCover
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(messageLabel)
        adjustLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func adjustLayout() {
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top).offset(UIDevice.current.separateValue(forPad: -60, forPhone: -30))
            $0.height.width.equalTo(UIDevice.current.separateValue(forPad: 200, forPhone: 100))
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(UIDevice.current.separateValue(forPad: 60, forPhone: 30))
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
    }
}
