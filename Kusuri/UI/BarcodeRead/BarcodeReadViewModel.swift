//
//  CameraViewReactor.swift
//  Kusuri
//
//  Created by Yus Inoue on 2021/10/01.
//

import Foundation
import RxSwift
import RxCocoa
import Vision

final class BarcodeReadViewModel {
    var router: BarcodeReadRouter!
    private let disposeBag = DisposeBag()
    
    struct Input {
        let barcode: Driver<VNBarcodeObservation>
        let showDetailButtonTapped: Signal<()>
        let reStartButtonTapped: Signal<()>
    }
    
    struct Output {
        let url: Driver<String?>
    }
    
    func transform(input: Input) -> Output {
        let gs1Barcode = input.barcode
            .filter({ VNBarcodeObservation in
                VNBarcodeObservation.symbology == .gs1DataBarLimited ||
                VNBarcodeObservation.symbology == .gs1DataBar
            })
        
        let url = gs1Barcode
            .map({ VNBarcodeObservation in
                VNBarcodeObservation.payloadStringValue
            })
            .asDriver()
        
        input.showDetailButtonTapped
            .asObservable()
            .withLatestFrom(url)
            .subscribe(with: self, onNext: { Object, String in
                let url = "https://www.pmda.go.jp/PmdaSearch/bookSearch/01/\(String!.dropFirst(2))"
                Object.router.showWebView(title: "添付文書", url: url)
            })
            .disposed(by: disposeBag)
        
        return Output(
            url: url
        )
    }
}
