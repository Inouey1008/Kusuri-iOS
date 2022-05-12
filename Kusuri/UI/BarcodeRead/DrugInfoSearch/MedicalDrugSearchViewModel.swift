//
//  MedicalDrugSearchViewModel.swift
//  Kusuri
//
//  Created by Yusuke Inoue on 2022/05/06.
//

import Foundation
import RxSwift
import RxCocoa

final class MedicalDrugSearchViewModel {
    var router: MedicalDrugSearchRouter!
    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchWord: Driver<String>
        let searchButtonClicked: Signal<()>
    }

    struct Output {
        let searching: Driver<Bool>
        let drugInfoes: Driver<[DrugInfo]>
    }

    func transform(input: Input) -> Output {
        let searching = ActivityIndicator()

        let medicalDrugInfoes = input.searchButtonClicked
            .withLatestFrom(input.searchWord)
            .flatMapLatest({ String in
                DrugInfoAPI.medicalSearch(String)
                    .trackActivity(searching)
                    .asDriver(onErrorDriveWith: .empty())
            })

        return Output(
            searching: searching.asDriver(),
            drugInfoes: medicalDrugInfoes
        )
    }
}
