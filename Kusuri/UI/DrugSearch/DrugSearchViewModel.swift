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
        let initialized: Driver<Bool>
        let searching: Driver<Bool>
        let searchSuccess: Driver<Bool>
        let searchError: Driver<Bool>
        let networkError: Driver<Bool>
        let drugInfoes: Driver<[DrugInfo]>
    }
    
    enum State: Equatable {
        case initialized
        case searching
        case searchSuccess
        case searchError
        case networkError
    }
    
    func transform(input: Input) -> Output {
        input.drugInfoTapped
            .emit (with: self, onNext: { Object, String in
                Object.router.showWebView(title: "添付文書", url: String)
            })
            .disposed(by: disposeBag)
        
        let searchWord = input.searchWord
        let state = BehaviorRelay<State>(value: .initialized)
        let drugInfoeRelay = BehaviorRelay<[DrugInfo]>(value: [])
        
        let searchResult = input.searchButtonTapped
            .asObservable()
            .withLatestFrom(searchWord)
            .flatMapLatest({ [weak self] String -> Observable<Event<[DrugInfo]>> in
                guard let self = self, let searchType = self.searchType else {
                    return Observable.just(.next([]))
                }
                state.accept(.searching)
                
                switch searchType {
                case .medical:
                    return DrugInfoAPI.medicalSearch(String).asObservable().materialize()
                case .otc:
                    return DrugInfoAPI.otcSearch(String).asObservable().materialize()
                }
            })
  
        searchResult
            .compactMap({ $0.element })
            .subscribe(onNext: { drugInfoes in
                drugInfoeRelay.accept(drugInfoes)
                if drugInfoes.count == 0 {
                    state.accept(.searchError)
                } else {
                    state.accept(.searchSuccess)
                }
            })
            .disposed(by: disposeBag)

        searchResult
            .compactMap({ $0.error })
            .subscribe(onNext: { error in
                drugInfoeRelay.accept([])
                state.accept(.networkError)
            })
            .disposed(by: disposeBag)
        
        let initialized = state
            .asObservable()
            .map { $0 == .initialized }
            .asDriver(onErrorJustReturn: false)
        
        let searching = state
            .asObservable()
            .map { $0 == .searching }
            .asDriver(onErrorJustReturn: false)
        
        let searchSuccess = state
            .asObservable()
            .map { $0 == .searchSuccess }
            .asDriver(onErrorJustReturn: false)
        
        let searchError = state
            .asObservable()
            .map { $0 == .searchError }
            .asDriver(onErrorJustReturn: false)
        
        let networkError = state
            .asObservable()
            .map { $0 == .networkError }
            .asDriver(onErrorJustReturn: false)
        
        let drugInfoes = drugInfoeRelay.asDriver()
       
        return Output(
            initialized: initialized,
            searching: searching,
            searchSuccess: searchSuccess,
            searchError: searchError,
            networkError: networkError,
            drugInfoes: drugInfoes
        )
    }
}
