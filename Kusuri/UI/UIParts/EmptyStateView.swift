//
//  EmptyStateView.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/10/02.
//

import UIKit
import SnapKit

final class EmptyStateView: UIView {
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .weakText
        label.font = .largeRegular
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .weakText
        label.font = .mediumLight
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
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
        imageView.snp.makeConstraints({ make in
            let bottomOffset = UIDevice.current.separateValue(forPad: -60, forPhone: -40)
            let heightWidth = UIDevice.current.separateValue(forPad: 100, forPhone: 75)
            
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(bottomOffset)
            make.height.width.equalTo(heightWidth)
        })
        titleLabel.snp.makeConstraints({ make in
            let horizontalInset = UIDevice.current.separateValue(forPad: 60, forPhone: 30)
            
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(horizontalInset)
        })
        messageLabel.snp.makeConstraints({ make in
            let topOffset = UIDevice.current.separateValue(forPad: 60, forPhone: 30)
            let horizontalInset = UIDevice.current.separateValue(forPad: 60, forPhone: 30)
            
            make.top.equalTo(titleLabel.snp.bottom).offset(topOffset)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(horizontalInset)
        })
    }
}
