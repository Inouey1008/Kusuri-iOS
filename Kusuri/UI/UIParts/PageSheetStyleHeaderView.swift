//
//  ModalPresentationHeaderView.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/04/11.
//

import UIKit
import SnapKit

final class PageSheetStyleHeaderView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .mediumBold
        label.textColor = .text
        label.numberOfLines = 0
        return label
    }()

    let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "cancel")?.resize(size: CGSize(width: 40, height: 40))?.withTintColor(.primary)
        button.setImage(image, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(closeButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        adjustLayout()
    }
    
    private func adjustLayout() {
        closeButton.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        closeButton.setContentHuggingPriority(.init(251), for: .horizontal)
        closeButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(36)
        }
        titleLabel.setContentCompressionResistancePriority(.init(749), for: .horizontal)
        titleLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(closeButton.snp.right).offset(8)
            $0.right.equalToSuperview().inset(52)   // !! closeButton.width(=36) + 16
            $0.centerY.equalToSuperview()
        }
        invalidateIntrinsicContentSize() // Viewの大きさを取得し直す
    }
    
    override var intrinsicContentSize: CGSize {
        let newWidth = super.intrinsicContentSize.width
        let newHeight = titleLabel.frame.height + 20
        let newSize = CGSize(width: newWidth, height: newHeight <= 55 ? 55 : newHeight)
        return newSize
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func addAction(_ action: @escaping UIActionHandler) {
        closeButton.addAction(UIAction(handler: action), for: .touchUpInside)
    }
}
