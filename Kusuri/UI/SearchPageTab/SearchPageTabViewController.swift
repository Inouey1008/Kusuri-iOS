//
//  SearchPageTabViewController.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/08/14.
//

import UIKit
import XLPagerTabStrip

final class SearchPageTabViewController: ButtonBarPagerTabStripViewController {
    var viewModel: SearchPageTabViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .backgroundCover
        let titleLabel = UILabel()
        titleLabel.text = "検索"
        titleLabel.textColor = .strongText
        titleLabel.font = .largeRegular
        navigationItem.titleView = titleLabel
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        settings.style.buttonBarHeight = UIDevice.current.separateValue(forPad: 66, forPhone: 44)
        settings.style.buttonBarBackgroundColor = .backgroundBase
        settings.style.buttonBarItemBackgroundColor = .backgroundBase
        settings.style.buttonBarItemFont = .mediumRegular
        settings.style.buttonBarItemTitleColor = .text
        settings.style.selectedBarHeight = UIDevice.current.separateValue(forPad: 4, forPhone: 2)
        settings.style.selectedBarBackgroundColor = .primary
        return [DrugSearchRouter.generate(type: .medical), DrugSearchRouter.generate(type: .otc)]
    }
}
