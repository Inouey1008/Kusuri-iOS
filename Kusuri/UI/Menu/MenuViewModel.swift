//
//  MenuViewModel.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/06.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class MenuViewModel {
    private let disposeBag = DisposeBag()
    var router: MenuRouter!
    
    struct Input {
        let itemSelected: Signal<IndexPath>
    }

    struct Output {
        let items: Driver<[MenuSectionModel]>
    }
    
    func transform(input: Input) -> Output {
        let items = [
            MenuSectionModel(model: .support, items: [.contactUs, .appReview]),
            MenuSectionModel(model: .app, items: [.useTerms, .plivacyPolicy, .version])
        ]
        
        input.itemSelected
            .emit(onNext: { [weak self] IndexPath in
                guard let self = self else { return }
                let selectedSection = items[IndexPath.section]
                let selectedItem = selectedSection.items[IndexPath.row]
                
                switch selectedItem {
                case .contactUs:
                    self.router.openBrowser("https://forms.gle/8mjR8ds8cuwMPRcf9")
                case .appReview:
                    self.router.openBrowser("https://apps.apple.com/us/app/id1622959628?action=write-review")
                case .useTerms:
                    self.router.showWebView(title: selectedItem.title, url: "https://sites.google.com/view/kusuri-app/use-terms")
                case .plivacyPolicy:
                    self.router.showWebView(title: selectedItem.title, url: "https://sites.google.com/view/kusuri-app/privacy-policy")
                case .version:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            items: Driver.just(items)
        )
    }
}
