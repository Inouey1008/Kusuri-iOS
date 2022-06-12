//
//  SearchTableViewCell.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/10/05.
//

import UIKit
import SnapKit

final class DrugInfoListCell: UITableViewCell {

    private lazy var cellArea: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundBase
        let borderColor = UITraitCollection.current.separateValue(dark: UIColor.strongestGray.cgColor, light: UIColor.weakGray.cgColor)
        view.layer.borderColor = borderColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = false
        return view
    }()

    private lazy var tradeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .mediumRegular
        label.textColor = .strongText
        label.numberOfLines = 0
        return label
    }()

    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.font = .smallLight
        label.textColor = .weakText
        label.numberOfLines = 0
        return label
    }()

    override init(style _: UITableViewCell.CellStyle, reuseIdentifier _: String?) {
        super.init(style: .value1, reuseIdentifier: Self.reuseIdentifier)
        isUserInteractionEnabled = true
        selectionStyle = .none
        backgroundColor = .backgroundCover
        addSubviews()
        adjustLayout()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(cellArea)
        cellArea.addSubview(tradeNameLabel)
        cellArea.addSubview(companyLabel)
    }

    private func adjustLayout() {
        tradeNameLabel.snp.makeConstraints({ make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(16)
        })
        companyLabel.snp.makeConstraints({ make in
            make.top.equalTo(tradeNameLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(10)
        })
        cellArea.snp.makeConstraints({ make in
            let verticalInset = UIDevice.current.separateValue(forPad: 10, forPhone: 5)
            let horizontalInset = UIDevice.current.separateValue(forPad: 24, forPhone: 16)
            
            make.top.bottom.equalToSuperview().inset(verticalInset)
            make.left.right.equalToSuperview().inset(horizontalInset)
        })
    }

    func configure(drugInfo: DrugInfo) {
        tradeNameLabel.text = drugInfo.tradeName
        companyLabel.text = drugInfo.company
    }
}
