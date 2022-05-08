//
//  MenuViewController.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/06.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit

final class MenuViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel: MenuViewModel!
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(), style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.contentInset.bottom = 12
        tableView.rowHeight = UIDevice.current.separateValue(forPad: 66, forPhone: 44)
        tableView.sectionHeaderHeight = 60
        tableView.sectionFooterHeight = 0
        tableView.dataSource = nil
        tableView.delegate = nil
        return tableView
    }()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MenuSectionModel>(
        configureCell: { [weak self] (dataSource, tableView, index, _) in
            let item = dataSource[index]
            var content: UIListContentConfiguration = .valueCell()
            content.text = item.title
            content.textProperties.font = .mediumRegular
            content.textProperties.color = .text
            content.secondaryText = item.description
            content.secondaryTextProperties.font = .mediumLight
            content.secondaryTextProperties.color = .weakText
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: index)
            cell.accessoryView = item.accessoryView
            cell.selectionStyle = item.selectionStyle
            cell.contentConfiguration = content
            return cell
        },
        titleForHeaderInSection: { [weak self] dataSource, index in
            return dataSource[index].model.title
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleLabel = UILabel()
        titleLabel.text = "メニュー"
        titleLabel.textColor = .strongText
        titleLabel.font = .largeRegular
        navigationItem.titleView = titleLabel
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = false
        view.isUserInteractionEnabled = true
        view.backgroundColor = .backgroundCover
        view.addSubview(tableView)
        adjustLayout()
        bind()
        addActions()
    }
    
    private func adjustLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        let input = MenuViewModel.Input(
            itemSelected: tableView.rx.itemSelected.asSignal()
        )
        
        let output = viewModel.transform(input: input)
        
        output.items
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func addActions() {
        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
