//
//  DrugSearchViewModel.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/06.
//

import Foundation
import RxSwift
import RxCocoa

final class DrugSearchViewModel {
    var router: DrugSearchRouter!
    private let disposeBag = DisposeBag()
    var searchType: SearchType!
    
    struct Input {
        let searchWord: Driver<String>
        let searchButtonTapped: Signal<()>
        let drugInfoTapped: Signal<String>
    }

    struct Output {
        let initialised: Driver<Bool>
        let searching: Driver<Bool>
        let empty: Driver<Bool>
        let listing: Driver<Bool>
        let drugInfoes: Driver<[DrugInfo]>
    }
    
    func transform(input: Input) -> Output {
        input.drugInfoTapped
            .emit (with: self, onNext: { Object, String in
                Object.router.showWebView(title: "添付文書", url: String)
            })
            .disposed(by: disposeBag)
        
        let searchWord = input.searchWord
        let activityIndicator = ActivityIndicator()
        let searching = activityIndicator.asDriver()
        
        let drugInfoes = input.searchButtonTapped
            .withLatestFrom(searchWord)
            .flatMapLatest({ [weak self] String -> Driver<[DrugInfo]> in
                switch self?.searchType {
                case .medical:
                    return DrugInfoAPI.medicalSearch(String).trackActivity(activityIndicator).asDriver(onErrorDriveWith: .empty())
                case .otc:
                    return DrugInfoAPI.otcSearch(String).trackActivity(activityIndicator).asDriver(onErrorDriveWith: .empty())
                case .none:
                    return Driver.of([])
                }
            })
       
        let initialised = input.searchButtonTapped
            .map({ false })
            .asDriver(onErrorDriveWith: .empty())
        
        let empty = Driver.combineLatest(drugInfoes, searching) { (drugInfoes, searching) -> Bool in
                drugInfoes.count == 0 && searching == false
            }.asDriver()
        
        let listing = Driver.combineLatest(drugInfoes, searching) { (drugInfoes, searching) -> Bool in
                drugInfoes.count > 0 && searching == false
            }.asDriver()

        return Output(
            initialised: initialised,
            searching: searching,
            empty: empty,
            listing: listing,
            drugInfoes: drugInfoes
        )
    }
}
