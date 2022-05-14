//
//  MedicalDrugSearchViewController.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import XLPagerTabStrip

class MedicalDrugSearchViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel: MedicalDrugSearchViewModel!
    
    private var titleMessageSet: [(title: String, message: String)] = [
        (title: "医療用医薬品を検索する", message: "病院やクリニックで処方される\n薬を検索します"),
        (title: "検索結果が0件あるいは1000件以上でした", message: "検索ワードを変えてもう一度お試しください"),
    ]
    
    private let emptyStateView = EmptyStateView()
    private let spinnerView = SpinnerView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .backgroundCover
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.register(DrugInfoListCell.self, forCellReuseIdentifier: "DrugInfoListCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isUserInteractionEnabled = true
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.showsHorizontalScrollIndicator = true
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "薬の名前を入力してください"
        searchBar.searchBarStyle = .default
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchTextField.textColor = .text
        searchBar.searchTextField.tintColor = .text
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.leftView?.tintColor = .gray
        searchBar.barTintColor = .background
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()
    
//    init(viewModel: MedicalDrugSearchViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundCover
        view.isUserInteractionEnabled = true
        view.addSubview(searchBar)
        view.addSubview(emptyStateView)
        view.addSubview(tableView)
        view.addSubview(spinnerView)
        adjustLayout()
        bind()
        addActions()
        
        emptyStateView.titleLabel.text = titleMessageSet[0].title
        emptyStateView.messageLabel.text = titleMessageSet[0].message
    }
    
    private func adjustLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(UITabBarController().tabBar.frame.size.height)
        }
        emptyStateView.snp.makeConstraints {
            $0.center.edges.equalTo(tableView)
        }
        spinnerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        let input = MedicalDrugSearchViewModel.Input(
            searchWord: searchBar.rx.text.orEmpty.asDriver(),
            searchButtonClicked: searchBar.rx.searchButtonClicked.asSignal()
        )

        let output = viewModel.transform(input: input)

        output.drugInfoes
            .drive(tableView.rx.items(cellIdentifier: "DrugInfoListCell", cellType: DrugInfoListCell.self)) { (row, element, cell) in
                cell.configure(drugInfo: element)
            }
            .disposed(by: disposeBag)
        
        output.drugInfoes
            .map { $0.count != 0 }
            .drive(emptyStateView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.drugInfoes
            .map { $0.count == 0 }
            .drive(tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.drugInfoes
            .asObservable()
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.emptyStateView.isHidden = true    // TODO: リファクタ！
            }
            .disposed(by: disposeBag)

        output.searching
            .drive(spinnerView.rx.animating)
            .disposed(by: disposeBag)

        output.searching
            .drive(tableView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func addActions() {
        searchBar.rx
            .searchButtonClicked
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(DrugInfo.self)
            .subscribe(onNext: { [weak self] druginfo in
                guard let self = self else { return }
                self.view.endEditing(true)
                self.showDetail(url: druginfo.url, title: druginfo.tradeName)
            })
            .disposed(by: disposeBag)
    }
    
    private func showDetail(url: String, title: String) {
        let viewController = DrugInfoDetailViewController(url: url, title: title)
        viewController.modalPresentationStyle = .pageSheet
        self.present(viewController, animated: true, completion: nil)
    }
}

extension MedicalDrugSearchViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "医療用医薬品")
    }
}
