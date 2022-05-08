//
//  CustomCoachMarkBodyView.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/10/05.
//

import UIKit
import SnapKit
//import Instructions
//
//final class CustomCoachMarkBodyView: UIView, CoachMarkBodyView {
//
//    var nextControl: UIControl? { return self.nextButton }
//    weak var highlightArrowDelegate: CoachMarkBodyHighlightArrowDelegate?
//
//    var nextButton = UIButton().apply {
//        $0.isUserInteractionEnabled = true
//        $0.setTitleColor(.primary, for: .normal)
//        $0.backgroundColor = .white
//        $0.layer.borderWidth = 1.0
//        $0.layer.borderColor = UIColor.primary.cgColor
//        $0.titleLabel?.font = .mediumRegular
//        $0.clipsToBounds = true
//        $0.layer.cornerRadius = 18
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    var hintLabel = UITextView().apply {
//        $0.backgroundColor = .clear
//        $0.textColor = UIColor.darkGray
//        $0.font = .mediumBold
//        $0.isScrollEnabled = false
//        $0.textAlignment = .center
//        $0.isEditable = false
//        $0.isUserInteractionEnabled = false
//        $0.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    convenience init() {
//        self.init(frame: CGRect.zero)
//    }
//
//    override init (frame: CGRect) {
//        super.init(frame: frame)
//        translatesAutoresizingMaskIntoConstraints = false   // !! これがないと画面に描画されない
//        backgroundColor = .white
//
//        clipsToBounds = true
//        layer.cornerRadius = 16
//
//        addSubview(hintLabel)
//        addSubview(nextButton)
//
//        hintLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(16)
//            $0.centerX.equalToSuperview()
//            $0.width.equalToSuperview().inset(16)
//        }
//        nextButton.snp.makeConstraints {
//            $0.top.equalTo(hintLabel.snp.bottom).offset(8)
//            $0.centerX.equalToSuperview()
//            $0.width.equalToSuperview().multipliedBy(0.5)
//            $0.height.equalTo(40)
//            $0.bottom.equalToSuperview().inset(16)
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("This class does not support NSCoding.")
//    }
//}
