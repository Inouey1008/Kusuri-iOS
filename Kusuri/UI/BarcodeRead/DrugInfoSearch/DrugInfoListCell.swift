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
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = false
        return view
    }()

    private lazy var tradeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .largeBold
        label.textColor = .strongText
        label.numberOfLines = 0
        return label
    }()

    private lazy var companyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
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
        tradeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.left.right.equalToSuperview().inset(16)
        }
        companyLabel.snp.makeConstraints {
            $0.top.equalTo(tradeNameLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(10)
        }
        cellArea.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(5)
            $0.left.right.equalToSuperview().inset(8)
        }
    }

    func configure(drugInfo: DrugInfo) {
        tradeNameLabel.text = drugInfo.tradeName
        companyLabel.text = drugInfo.company
    }
}
