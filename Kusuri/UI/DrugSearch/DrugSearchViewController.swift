//
//  DrugSearchViewController.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import XLPagerTabStrip

final class DrugSearchViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel: DrugSearchViewModel!
    var searchType: SearchType!

    private lazy var initialisedView: EmptyStateView = {
        let view = EmptyStateView()
        view.imageView.tintColor =  .weakText
        
        switch searchType {
        case .medical:
            view.imageView.image = UIImage(systemName: "cross.case")
            view.titleLabel.text = "医療用医薬品を検索する"
            view.messageLabel.text = "病院やクリニックで処方される\n薬を検索します"
        case .otc:
            view.imageView.image = UIImage(systemName: "pills")
            view.titleLabel.text = "一般用医薬品を検索する"
            view.messageLabel.text = "薬局やドラッグストアで買える\n薬を検索します"
        case .none:
            fatalError()
        }
        return view
    }()
    
    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.imageView.image = UIImage(systemName: "questionmark.circle")
        view.imageView.tintColor = .weakText
        view.titleLabel.text = "検索結果が0件あるいは1000件以上でした"
        view.messageLabel.text = "検索ワードを変えてもう一度お試しください"
        return view
    }()
    
    private let noNetworkView: EmptyStateView = {
        let view = EmptyStateView()
        view.imageView.image = UIImage(systemName: "wifi.slash")
        view.imageView.tintColor = .weakText
        view.titleLabel.text = "インターネット接続がありません"
        view.messageLabel.text = "良好な通信環境でもう一度お試しください"
        return view
    }()
    
    private let indicatorView = IndicatorView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .backgroundCover
        tableView.separatorStyle = .none
        tableView.register(DrugInfoListCell.self, forCellReuseIdentifier: "DrugInfoListCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isUserInteractionEnabled = true
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.showsHorizontalScrollIndicator = true
        tableView.keyboardDismissMode = .onDrag
        
        let footerView = UIView()
        footerView.frame.size = CGSize(width: 0, height: UIDevice.current.separateValue(forPad: 16, forPhone: 10))
        tableView.tableFooterView = footerView
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "薬の名前を入力してください"
        searchBar.searchBarStyle = .default
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.font = .systemFont(ofSize: UIDevice.current.separateValue(forPad: 25, forPhone: 16))
        searchBar.searchTextField.textColor = .text
        searchBar.searchTextField.tintColor = .text
        searchBar.searchTextField.backgroundColor = .backgroundBase
        searchBar.searchTextField.leftView?.tintColor = .gray
        searchBar.searchTextField.inputAccessoryView = toolBar
        searchBar.barTintColor = .backgroundBase
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
    private lazy var toolBar: UIToolbar = {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.sizeToFit()
        toolBar.items = [spacer, doneButton]
        return toolBar
    }()
    
    private let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    
    private let emptyTapGesture = UITapGestureRecognizer()
    private let initialisedTapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundCover
        view.isUserInteractionEnabled = true
        view.addSubview(searchBar)
        view.addSubview(initialisedView)
        view.addSubview(emptyStateView)
        view.addSubview(noNetworkView)
        view.addSubview(tableView)
        view.addSubview(indicatorView)
        
        emptyStateView.addGestureRecognizer(emptyTapGesture)
        initialisedView.addGestureRecognizer(initialisedTapGesture)
        
        adjustLayout()
        bind()
        addActions()
        
        initialisedView.isHidden = false
        emptyStateView.isHidden = true
        noNetworkView.isHidden = true
        tableView.isHidden = true
    }
    
    private func adjustLayout() {
        searchBar.snp.makeConstraints({ make in
            let topPadding = UIDevice.current.separateValue(forPad: 20, forPhone: 16)
            let horizontalPadding = UIDevice.current.separateValue(forPad: 16, forPhone: 8)
            let height = UIDevice.current.separateValue(forPad: 50, forPhone: 40)
            
            make.top.equalTo(view.safeAreaLayoutGuide).inset(topPadding)
            make.left.right.equalToSuperview().inset(horizontalPadding)
            make.height.equalTo(height)
        })
        tableView.snp.makeConstraints({ make in
            let topPadding = UIDevice.current.separateValue(forPad: 16, forPhone: 10)
            let bottomPadding = UITabBarController().tabBar.frame.size.height
            
            make.top.equalTo(searchBar.snp.bottom).offset(topPadding)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(bottomPadding)
        })
        initialisedView.snp.makeConstraints({ make in
            make.center.edges.equalTo(tableView)
        })
        emptyStateView.snp.makeConstraints({ make in
            make.center.edges.equalTo(tableView)
        })
        noNetworkView.snp.makeConstraints({ make in
            make.center.edges.equalTo(tableView)
        })
        indicatorView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
    }
    
    private func bind() {
        let input = DrugSearchViewModel.Input(
            searchWord: searchBar.rx.text.orEmpty.asDriver(),
            searchButtonTapped: searchBar.rx.searchButtonClicked.asSignal(),
            drugInfoTapped: tableView.rx.modelSelected(DrugInfo.self).map({ $0.url }).asSignal(onErrorSignalWith: .empty())
        )

        let output = viewModel.transform(input: input)

        output.drugInfoes
            .drive(tableView.rx.items(cellIdentifier: "DrugInfoListCell", cellType: DrugInfoListCell.self)) { (row, element, cell) in
                cell.configure(drugInfo: element)
            }
            .disposed(by: disposeBag)
     
        output.searchSuccess
            .map({ !$0 })
            .drive(tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.initialized
            .map({ !$0 })
            .drive(initialisedView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.searchError
            .map({ !$0 })
            .drive(emptyStateView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.networkError
            .map({ !$0 })
            .drive(noNetworkView.rx.isHidden)
            .disposed(by: disposeBag)

        output.searching
            .drive(indicatorView.rx.animating)
            .disposed(by: disposeBag)
    }
    
    private func addActions() {
        searchBar.rx.searchButtonClicked
            .subscribe(with: self, onNext: { Object, _ in
                Object.view.endEditing(true)
            })
            .disposed(by: disposeBag)

        emptyTapGesture.rx.event
            .subscribe(with: self, onNext: { Object, _ in
                Object.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        initialisedTapGesture.rx.event
            .subscribe(with: self, onNext: { Object, _ in
                Object.view.endEditing(true)
            })
            .disposed(by: disposeBag)

        doneButton.rx.tap
            .subscribe(with: self, onNext: { Object, _ in
                Object.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
}

extension DrugSearchViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        switch searchType {
        case .medical:
            return IndicatorInfo(title: "医療用医薬品")
        case .otc:
            return IndicatorInfo(title: "一般用医薬品")
        case .none:
            fatalError()
        }
    }
}
